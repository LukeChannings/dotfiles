{ inputs, lib, ... }:
let
  filesCalled =
    with inputs.nixpkgs.lib.fileset;
    name: toList (fileFilter (file: file.name == name) ./.);

  importAsAttrset =
    with builtins;
    pathList:
    listToAttrs (
      map (path: {
        name = baseNameOf (dirOf path);
        value = import path;
      }) pathList
    );

  stateVersion = "24.05";
  nixDarwinStateVersion = 4;

  homeModules = (importAsAttrset (filesCalled "home.nix")) // {
    _setup = (
      { pkgs, ... }:
      {
        nixpkgs.config.allowUnfree = true;
        home.stateVersion = stateVersion;
        nix.package = lib.mkForce pkgs.nixVersions.latest;
        xdg.enable = true;
      }
    );
    default-packages = import ./default-packages.nix;
    nix-index-database = inputs.nix-index-database.hmModules.nix-index;
  };

  darwinModules = (importAsAttrset (filesCalled "darwin.nix")) // {
    home-manager = inputs.home-manager.darwinModules.home-manager;
    brew-nix = inputs.brew-nix.darwinModules.default;
    link-apps = inputs.toolbox.modules.darwin.link-apps;

    _setup = {
      system.stateVersion = nixDarwinStateVersion;

      nixpkgs.config.allowUnfree = true;
    };
  };

  nixosModules = (importAsAttrset (filesCalled "nixos.nix")) // {
    home-manager = inputs.home-manager.nixosModules.default;

    _setup = {
      system.stateVersion = stateVersion;

      nixpkgs.config.allowUnfree = true;
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
      pkgs,
      config,
      disabledModules ? [ ],
    }:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      modules = [ config ] ++ (homeModulesWithDisabled disabledModules);

      extraSpecialArgs = {
        inherit pkgs inputs;
      };
    };
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
        ;
    };

    modules = {
      homeManager = homeModules;
      nixos = nixosModules;
      darwin = darwinModules;
    };
  };
}
