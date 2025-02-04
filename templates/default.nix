{ ... }:
{
  flake.templates = {
    darwin-system = {
      description = "Create a nix-darwin system configuration";
      path = ./darwin-system;
    };

    dev-base = {
      description = "A barebones TypeScript frontend environment";
      path = ./dev-base;
    };

    dev-fe-ts = {
      description = "A barebones TypeScript frontend environment";
      path = ./dev-fe-typescript;
    };

    shell-nodejs = {
      description = "A NodeJS shell";
      path = ./shell-nodejs;
    };
  };
}
