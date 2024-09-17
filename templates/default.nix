{ ... }:
{
  flake.templates = {
    devenv = {
      description = "Create a barebones devenv";
      path = ./devenv;
    };

    darwin-system = {
      description = "Create a nix-darwin system configuration";
      path = ./darwin-system;
    };
  };
}
