# Base profile – contains the bare minimum for a headless environment
{ self, ... }:
let
  homeManagerProfile =
    { pkgs, vscode-extensions, ... }:
    {
      imports = [
        self.homeModules.atuin
        self.homeModules.bat
        self.homeModules.editorconfig
        self.homeModules.eza
        self.homeModules.fish
        self.homeModules.git
        self.homeModules.helix
        self.homeModules.htop
        self.homeModules.nixpkgs
        self.homeModules.ssh
        self.homeModules.starship
        self.homeModules.zoxide
      ];

      home.stateVersion = "24.11";
      home.enableNixpkgsReleaseCheck = false;
      xdg.enable = true;

      nixpkgs.overlays = [
        self.overlays.default
        vscode-extensions.overlays.default
      ];

      home.packages = with pkgs; [
        # File Management
        tree
        ncdu

        # Networking tools
        dig
        curl
        jq

        # Other
        ripgrep
        chafa
      ];
    };
  homeManagerConfig = ({ inputs, pkgs, ... }: {
    environment.systemPackages = [ pkgs.home-manager ];

    home-manager.sharedModules = [ homeManagerProfile ];
    home-manager.useUserPackages = true;
    home-manager.useGlobalPkgs = false;
    home-manager.extraSpecialArgs = inputs // {
      pkgsPath = if inputs ? nixpkgs-latest then inputs.nixpkgs-latest else inputs.nixpkgs;
    };
  });
  nixosProfile =
    {
      inputs,
      pkgs,
      lix-module,
      home-manager,
      vscode-extensions,
      ...
    }:
    {
      system.stateVersion = "24.11";

      imports = [
        lix-module.nixosModules.default

        home-manager.nixosModules.home-manager
        homeManagerConfig

        self.nixosModules.pki
        self.nixosModules.nix
        self.nixosModules.nixpkgs
        "${self}/modules/nixos/diff-system.nix"
      ];

      programs.nano.enable = false;

      system.switch.enableNg = true;

      nixpkgs.overlays = [
        vscode-extensions.overlays.default
      ];
    };
  darwinProfile =
    {
      pkgs,
      inputs,
      home-manager,
      lix-module,
      vscode-extensions,
      ...
    }:
    {
      system.stateVersion = 5;

      imports = [
        lix-module.nixosModules.default

        home-manager.darwinModules.home-manager
        homeManagerConfig

        self.darwinModules.brew
        self.darwinModules.pki
        self.darwinModules.nix
        self.darwinModules.nixpkgs
      ];

      nixpkgs.overlays = [
        self.overlays.default
        vscode-extensions.overlays.default
      ];
    };
in
{
  flake.homeManagerProfiles.base = homeManagerProfile;
  flake.nixosProfiles.base = nixosProfile;
  flake.darwinProfiles.base = darwinProfile;
}
