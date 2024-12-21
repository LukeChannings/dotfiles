{ inputs, ... }:
let
  inherit (builtins) attrValues;
  inherit (inputs) dotfiles darwin;
in
{
  flake.darwinConfigurations.default = darwin.lib.darwinSystem {
    system = "aarch64-darwin";

    inherit inputs;

    modules = [
      (dotfiles.lib.configureOsModules {
        osModules = attrValues dotfiles.modules.darwin;
        homeModules = dotfiles.lib.homeModulesWithDisabled [ "default-apps" ];
      })
      (
        let
          username = "runner";
        in
        { lib, ... }:
        {
          # This can be removed for multi-user Nix installs
          nix.gc.user = username;

          nix.linux-builder.enable = lib.mkForce false;

          nixpkgs.overlays = [ dotfiles.overlays.vscode-extensions ];

          users = {
            knownUsers = [ username ];

            users.${username} = {
              home = "/Users/${username}";
              uid = 502;
            };
          };
        }
      )
    ];
  };
}
