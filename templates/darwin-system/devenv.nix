{ inputs, ... }:
{
  imports = [
    inputs.devenv.flakeModule
    inputs.treefmt-nix.flakeModule
  ];

  perSystem =
    {
      config,
      pkgs,
      lib,
      system,
      ...
    }:
    {
      treefmt = {
        projectRoot = ./.;
        projectRootFile = "flake.nix";

        programs.nixfmt.enable = true;
        programs.deadnix.enable = true;
        programs.biome = {
          enable = true;
          settings.formatter.indentStyle = "space";
        };
      };

      devenv.shells.default = {
        devenv.root =
          let
            devenvRootFileContent = builtins.readFile inputs.devenv-root.outPath;
          in
          pkgs.lib.mkIf (devenvRootFileContent != "") devenvRootFileContent;

        imports = [ inputs.toolbox.modules.devenv.vscode-workspace ];

        packages = with pkgs; [
          lix
        ];

        vscode-workspace = {
          extensions = with inputs.vscode-extensions.extensions.${system}.vscode-marketplace; [
            jnoortheen.nix-ide
            ibecker.treefmt-vscode
          ];

          settings = {
            nix = {
              enableLanguageServer = true;
              serverPath = lib.getExe pkgs.nil;
            };

            treefmt = {
              command = lib.getExe config.treefmt.package;
              config = config.treefmt.build.configFile;
            };

            editor.defaultFormatter = "ibecker.treefmt-vscode";
          };
        };
      };
    };
}
