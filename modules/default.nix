{ ... }: {
  flake.modules.homeManager = {
    default-packages = import ./homeManager/default-packages.nix;
    smallstep = import ./homeManager/smallstep.nix;
  };

  flake.flakeModules = {
    colmena = import ./flakeModules/colmena.nix;
  };
}
