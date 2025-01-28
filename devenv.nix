{ inputs, ... }:
{
  perSystem =
    {
      pkgs,
      lib,
      system,
      ...
    }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        inherit ((import ./config/nixpkgs).nixpkgs) config;
        overlays = [ inputs.vscode-extensions.overlays.default ];
      };

      treefmt = {
        projectRoot = ./.;
        projectRootFile = "flake.nix";
        programs.nixfmt.enable = true;
        programs.deadnix.enable = true;
        programs.biome = {
          enable = true;
          settings.formatter.indentStyle = "space";
        };
        programs.fish_indent.enable = true;
        programs.stylua.enable = true;
        programs.shellcheck.enable = true;
        programs.yamlfmt.enable = true;
        programs.actionlint.enable = true;
        programs.perltidy.enable = true;
      };

      devenv.shells.default = {
        devenv.root =
          let
            devenvRootFileContent = builtins.readFile inputs.devenv-root.outPath;
          in
          pkgs.lib.mkIf (devenvRootFileContent != "") devenvRootFileContent;

        imports = [ inputs.toolbox.modules.devenv.vscode-workspace ];

        devcontainer.enable = true;

        languages.shell.enable = true;

        devcontainer.settings.customizations.vscode.extensions =
          let
            globalExtensions = (import ./config/vscode/extensions.nix { inherit pkgs; });
            inherit (builtins) foldl' attrNames readDir;
          in
          foldl' (
            acc: extension: acc ++ (attrNames (readDir "${extension}/share/vscode/extensions"))
          ) [ ] globalExtensions;

        devcontainer.settings.updateContentCommand = "";

        vscode-workspace = {
          extensions = with pkgs.vscode-marketplace; [
            jnoortheen.nix-ide
            thenuprojectcontributors.vscode-nushell-lang
          ];

          settings = {
            nix = {
              enableLanguageServer = true;
              serverPath = lib.getExe pkgs.nil;
            };
          };
        };
      };
    };
}
