{
  self,
  inputs,
  lib,
  ...
}:
let
  inherit (lib) optional;
  inherit (lib.strings) toLower;
  inherit (lib.attrsets) genAttrs;

  filesCalled =
    with inputs.nixpkgs.lib.fileset;
    nameFilter:
    toList (fileFilter (file: (nameFilter file.name) || file.name == "home+nixos+darwin.nix") ./.);

  importAsAttrset =
    with builtins;
    pathList:
    listToAttrs (
      map (
        path:
        let
          type = (baseNameOf path);
        in
        {
          name = "${baseNameOf (dirOf path)}${
            if type == "nixos+darwin.nix" then
              "-os-shared"
            else if type == "home+nixos+darwin.nix" then
              "-shared"
            else
              ""
          }";
          value = import path;
        }
      ) pathList
    );

  stateVersion = "25.05";
  nixDarwinStateVersion = 5;

  #
  # To organise configurations I separate configurations into modules:
  #
  # - home.nix - home-manager modules
  # - darwin.nix - nix-darwin modules
  # - nixos.nix - nixos modules
  #
  # Available combinations:
  #
  # - home+nixos+darwin.nix
  # - nixos+darwin.nix
  #
  homeModules = (importAsAttrset (filesCalled (_: _ == "home.nix"))) // {
    _setup.home.stateVersion = stateVersion;
  };

  darwinModules =
    (importAsAttrset (filesCalled (_: _ == "darwin.nix" || _ == "nixos+darwin.nix")))
    // {
      _setup.system.stateVersion = nixDarwinStateVersion;
    };

  nixosModules = (importAsAttrset (filesCalled (_: _ == "nixos.nix" || _ == "nixos+darwin.nix"))) // {
    _setup.system.stateVersion = stateVersion;
  };

  disableModules =
    allModules: disabledModules: (with builtins; attrValues (removeAttrs allModules disabledModules));

  homeManagerModulesWithDisabled = disableModules self.modules.homeManager;
  darwinModulesWithDisabled = disableModules self.modules.darwin;
  nixosModulesWithDisabled = disableModules self.modules.nixos;

  configureOsModules =
    { osModules, homeManagerModules }:
    (
      {
        config,
        inputs,
        ...
      }:
      {
        imports = osModules;

        config.home-manager.sharedModules = homeManagerModules;
        config.home-manager.extraSpecialArgs = {
          inherit inputs;
        } // inputs;
      }
    );
  mkHomeManagerConfiguration =
    {
      pkgs,
      config ? {},
      disabledModules ? [ ],
      user ? { },
    }:
    (
      assert user.name != null;

      inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          {
            home.username = user.name;
            home.homeDirectory = "/home/${user.name}";
          }
          config
        ] ++ (homeManagerModulesWithDisabled disabledModules);

        extraSpecialArgs = {
          inherit inputs user;
        } // inputs;
      }
    );
  mkDarwinSystem =
    {
      hostName,
      user ? { },
      system ? "aarch64-darwin",
      inputs ? inputs,
      osModules ? builtins.attrValues self.modules.darwin,
      sharedHomeManagerModules ? builtins.attrValues self.modules.homeManager,
      userHomeModule ? null,
    }:
    (
      assert user.name != null;
      assert user.fullName != null;
      assert user.id != null;

      let
        inherit (inputs.darwin.lib) darwinSystem;
        systemCfg = darwinSystem {
          inherit system;

          modules =
            [
              (
                { lib, ... }:
                {
                  networking.hostName = hostName;
                  users.knownUsers = [ user.name ];
                  users.users.${user.name} = {
                    description = user.fullName;
                    home = "/Users/${user.name}";
                    uid = user.id;
                    gid = user.id;
                  };

                  home-manager.users.${user.name} = lib.mkIf (user ? gitEmail) {
                    programs.git.userName = user.fullName;
                    programs.git.userEmail = user.gitEmail;
                  };
                }
              )
              (configureOsModules {
                inherit osModules;
                homeManagerModules = sharedHomeManagerModules;
              })
            ]
            ++ (optional (userHomeModule != null) {
              home-manager.users.${user.name} = userHomeModule;
            });

          specialArgs = {
            inherit inputs user;
          } // inputs;
        };
      in
      genAttrs ([ hostName ] ++ (optional (hostName != (toLower hostName)) (toLower hostName))) (
        _: systemCfg
      )
    );
  mkNixOsSystem =
    {
      hostName,
      deployment,
      user ? null,
      system ? "x86_64-linux",
      inputs ? inputs,
      osModules ? builtins.attrValues self.modules.nixos,
      sharedHomeManagerModules ? builtins.attrValues self.modules.homeManager,
      userHomeModule ? { },
    }:
    (
      let
        systemModules = [
          (configureOsModules {
            inherit osModules;
            homeManagerModules = sharedHomeManagerModules;
          })

          {
            networking.hostName = hostName;

            users.mutableUsers = false;
          }
          {
            config =
              if (user != null) then
                (
                  assert user ? name;
                  {
                    users.users.${user.name} = { };
                    home-manager.users.${user.name} = userHomeModule;
                  }
                )
              else
                { };
          }
        ];
        systemCfg = inputs.nixpkgs.lib.nixosSystem {
          inherit system;

          modules = systemModules;

          specialArgs = {
            inherit inputs user;
          } // inputs;
        };
        normalizedHostName = (toLower hostName);
        hostNames = [ hostName ] ++ (optional (hostName != normalizedHostName) normalizedHostName);
      in
      {
        nixosConfigurations = genAttrs hostNames (_: systemCfg);
        colmena = {
          ${normalizedHostName} = {
            imports = systemModules;

            inherit deployment;
          };
          meta.nodeSpecialArgs.${normalizedHostName} = {
            inherit inputs;
          } // inputs;
        };
      }
    );
in
{
  flake = {
    lib = {
      inherit
        configureOsModules
        homeManagerModulesWithDisabled
        darwinModulesWithDisabled
        nixosModulesWithDisabled
        mkHomeManagerConfiguration
        mkDarwinSystem
        mkNixOsSystem
        ;
    };

    inherit homeModules nixosModules;

    modules = {
      homeManager = homeModules;
      nixos = nixosModules;
      darwin = darwinModules;
    };
  };
}
