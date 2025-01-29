{
  inputs,
  lib,
  config,
  ...
}:
let
  defaultOverlays = builtins.attrValues config.flake.overlays;

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

  stateVersion = "24.11";
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

    default-packages = import ./default-packages.nix;
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

  homeModulesWithDisabled = disableModules homeModules;
  darwinModulesWithDisabled = disableModules darwinModules;
  nixosModulesWithDisabled = disableModules nixosModules;

  configureOsModules =
    { osModules, homeModules }:
    (
      {
        config,
        inputs,
        ...
      }:
      {
        imports = osModules;

        config.home-manager.sharedModules = homeModules;
        config.home-manager.extraSpecialArgs = {
          inherit inputs;
        } // inputs;
      }
    );
  mkHomeManagerConfiguration =
    {
      config,
      overlays ? defaultOverlays,
      pkgs,
      disabledModules ? [ ],
    }:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      modules = [ config ] ++ (homeModulesWithDisabled disabledModules);

      extraSpecialArgs = {
        inherit inputs;
      } // inputs;
    };
  mkDarwinSystem =
    {
      hostName,
      user ? { },
      system ? "aarch64-darwin",
      inputs ? inputs,
      osModules ? builtins.attrValues darwinModules,
      sharedHomeModules ? builtins.attrValues homeModules,
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
                homeModules = sharedHomeModules;
              })
            ]
            ++ (optional (userHomeModule != null) {
              home-manager.users.${user.name} = userHomeModule;
            });

          specialArgs = {
            inherit inputs;
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
      osModules ? builtins.attrValues nixosModules,
      sharedHomeModules ? builtins.attrValues homeModules,
      userHomeModule ? { },
      overlays ? builtins.attrValues config.flake.overlays,
    }:
    (
      let
        systemModules = [
          (configureOsModules {
            inherit osModules;
            homeModules = sharedHomeModules;
          })

          {
            networking.hostName = hostName;

            users.mutableUsers = false;
            users.users.root.openssh.authorizedKeys.keys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMZzAdnH2X/vW+HEovUZCgDjfIiXyokxCNIhCDrF1+Rh"
            ];

            nix.settings.trusted-users = [
              "luke"
              "luke@idm.channings.me"
            ];
            # nixpkgs.overlays = overlays;
          }

          (
            { ... }:
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
          )
        ];
        systemCfg = inputs.nixpkgs.lib.nixosSystem {
          inherit system;

          modules = systemModules;

          specialArgs = {
            inherit inputs;
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
        homeModulesWithDisabled
        darwinModulesWithDisabled
        nixosModulesWithDisabled
        mkHomeManagerConfiguration
        mkDarwinSystem
        mkNixOsSystem
        ;
    };

    modules = {
      homeManager = homeModules;
      nixos = nixosModules;
      darwin = darwinModules;
    };
  };
}
