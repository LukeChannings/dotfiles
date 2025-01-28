{
  inputs,
  lib,
  config,
  ...
}:
let
  nixpkgsConfigModule = import ./nixpkgs/universal.nix;
  nixpkgsConfig = nixpkgsConfigModule.nixpkgs.config;
  defaultOverlays = builtins.attrValues config.flake.overlays;

  inherit (lib) optional;
  inherit (lib.strings) toLower;
  inherit (lib.attrsets) genAttrs;

  filesCalled =
    with inputs.nixpkgs.lib.fileset;
    name: toList (fileFilter (file: file.name == name || file.name == "universal.nix") ./.);

  importAsAttrset =
    with builtins;
    pathList:
    listToAttrs (
      map (path: {
        name = baseNameOf (dirOf path);
        value = import path;
      }) pathList
    );

  stateVersion = "24.11";
  nixDarwinStateVersion = 5;

  homeModules = (importAsAttrset (filesCalled "home.nix")) // {
    _setup = {
      home.stateVersion = stateVersion;
      xdg.enable = true;
    };
    default-packages = import ./default-packages.nix;
    nix-index-database = inputs.nix-index-database.hmModules.nix-index;
  };

  darwinModules = (importAsAttrset (filesCalled "darwin.nix")) // {
    inherit nixpkgsConfigModule;
    home-manager = inputs.home-manager.darwinModules.home-manager;
    brew-nix = inputs.brew-nix.darwinModules.default;
    link-apps = inputs.toolbox.modules.darwin.link-apps;

    _setup = {
      system.stateVersion = nixDarwinStateVersion;
    };
  };

  nixosModules = (importAsAttrset (filesCalled "nixos.nix")) // {
    home-manager = inputs.home-manager.nixosModules.default;

    _setup = {
      system.stateVersion = stateVersion;
    };
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
        pkgs,
        inputs,
        ...
      }:
      {
        imports = osModules;

        config = {
          home-manager = {
            backupFileExtension = "backup";

            sharedModules = homeModules;

            # Use the system-level nixpkgs instead of Home Manager's
            useGlobalPkgs = true;

            # Install packages to /etc/profiles instead of ~/.nix-profile, useful when
            # using multiple profiles for one user
            useUserPackages = true;

            extraSpecialArgs = {
              inherit pkgs inputs;
            };
          };
        };
      }
    );
  mkHomeManagerConfiguration =
    {
      system,
      config,
      overlays ? defaultOverlays,
      pkgs ? import inputs.nixpkgs { inherit system; config = nixpkgsConfig; inherit overlays; },
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

            nix.settings.trusted-users = [ "luke" "luke@idm.channings.me" ];
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
          meta.nodeNixpkgs.${normalizedHostName} = import inputs.nixpkgs {
            inherit system overlays;
            config = nixpkgsConfig;
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
