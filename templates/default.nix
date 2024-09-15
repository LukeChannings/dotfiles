{ ... }:
{
  flake.templates = {
    devenv = {
      description = "Create a barebones devenv";
      path = ./devenv;
    };
  };
}
