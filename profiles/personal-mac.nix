{ self, ... }:
let
  profileName = "personal-mac";
  homeManagerProfile =
    { pkgs, ... }:
    {
      imports = [
        self.homeModules.macos-login-items
        self.homeModules."1password"
        self.homeModules.attic
        self.homeModules.brew
        self.homeModules.chromium
        self.homeModules.direnv
        self.homeModules.fonts
        self.homeModules.ghostty
        self.homeModules.nushell
        self.homeModules.vscode
        self.homeModules.smallstep
      ];

      home.packages =
        (with pkgs.latest; [
          colima
          docker
          sops
          nix-tree
          minio-client
          zoom-us
          zotero
          devenv
        ])
        ++ (with pkgs.brewCasks; [
          apparency
          suspicious-package
          the-unarchiver

          raycast
          maccy
          swish
          contexts

          hot
          monitorcontrol

          postman
          tableplus
          mqtt-explorer
          chatgpt
          element
          logseq
        ]);

      dotfiles.loginItems = {
        Swish = "${pkgs.brewCasks.swish}/Applications/Swish.app";
        RaycastLauncher = "${pkgs.brewCasks.raycast}/Applications/Raycast.app/Contents/Library/LoginItems/RaycastLauncher.app";
        MonitorControl = "${pkgs.brewCasks.monitorcontrol}/Applications/MonitorControl.app";
        Maccy = "${pkgs.brewCasks.maccy}/Applications/Maccy.app";
      };

      dotfiles.attic.watch-daemon.enable = true;
      dotfiles.attic.watch-daemon.cache = "nix";

      programs.ssh.enableDefaultMacOSAgent = true;
      programs.ssh.enableSmallstep = true;
      programs.ssh.enable1PasswordAgent = true;
    };
in
{
  flake.homeManagerProfiles.${profileName} = homeManagerProfile;

  flake.darwinProfiles.${profileName} =
    { brew-nix, ... }:
    {
      imports = [
        self.darwinModules.darwin-defaults
      ];

      home-manager.sharedModules = [ homeManagerProfile ];

      nix.registry.cask.flake = brew-nix;
    };
}
