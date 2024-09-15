{ inputs, ... }:
{
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

        # TODO: Tailor these formatters for the current project
        programs.nixfmt.enable = true;
        programs.deadnix.enable = true;
        programs.biome = {
          enable = true;
          settings.formatter.indentStyle = "space";
        };
        programs.fish_indent.enable = true;
        programs.stylua.enable = true;
        programs.shellcheck.enable = true;
      };

      devenv.shells.default = {
        devenv.root =
          let
            devenvRootFileContent = builtins.readFile inputs.devenv-root.outPath;
          in
          pkgs.lib.mkIf (devenvRootFileContent != "") devenvRootFileContent;

        imports = [ inputs.toolbox.devenvModules.vscode-workspace ];

        devcontainer.enable = true;

        languages.shell.enable = true;

        packages = with pkgs; [
          nixVersions.latest
        ];

        devcontainer.settings.customizations.vscode.extensions = [ "mkhl.direnv" ];
        devcontainer.settings.updateContentCommand = "";

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
