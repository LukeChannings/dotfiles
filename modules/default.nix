{ ... }: {
  flake.homeModules = {
    macos-login-items = import ./homeManager/macos-login-items.nix;
    smallstep = import ./homeManager/smallstep.nix;
  };

  flake.flakeModules = {
    colmena = import ./flakeModules/colmena.nix;
    nix-darwin = import ./flakeModules/nix-darwin.nix;
  };
}
