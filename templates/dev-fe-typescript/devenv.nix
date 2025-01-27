{ inputs, ... }:
{
  perSystem =
    {
      pkgs,
      lib,
      ...
    }:
    {
      treefmt = {
        projectRootFile = "./flake.nix";

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

        imports = [ inputs.toolbox.modules.devenv.vscode-workspace ];

        dotenv.enable = true;

        devcontainer.enable = true;

        languages.shell.enable = true;
        languages.javascript.enable = true;
        languages.javascript.package = pkgs.nodejs_23;
        languages.javascript.corepack.enable = true;
        languages.javascript.npm.enable = true;
        languages.javascript.npm.install.enable = true;
        languages.typescript.enable = true;

        devcontainer.settings.customizations.vscode.extensions = [ "mkhl.direnv" ];
        devcontainer.settings.updateContentCommand = "";

        vscode-workspace = {
          extensions = with pkgs.vscode-marketplace; [
            jnoortheen.nix-ide
          ];

          settings = {
            nix = {
              enableLanguageServer = true;
              serverPath = lib.getExe pkgs.nil;
            };

            editor.defaultFormatter = "ibecker.treefmt-vscode";
          };
        };
      };
    };
}
