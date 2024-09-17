{ inputs, ... }:
let
  inherit (builtins) attrValues;
  inherit (inputs) dotfiles nix-darwin;
in
{
  flake.darwinConfigurations.default = nix-darwin.lib.darwinSystem {
    system = "aarch64-darwin";

    inherit inputs;

    modules = [
      (dotfiles.lib.configureOsModules {
        osModules = attrValues dotfiles.modules.darwin;
        homeModules = attrValues dotfiles.modules.homeModules;
      })
      (
        let
          username = "luke";
        in
        { ... }:
        {
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
