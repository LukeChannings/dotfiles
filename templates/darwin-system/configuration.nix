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
        homeModules = attrValues dotfiles.modules.homeManager;
      })
      (
        let
          username = "runner";
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
