{
  pkgs,
  lib,
  config,
  ...
}:
{
  programs.fish = {
    enable = true;

    shellInitLast = lib.mkIf config.programs.starship.enable ''
      status is-interactive; and begin
        enable_transience

        # Set QEMU=1 if we're in QEMU
        if command -q systemd-detect-virt; and [ $(systemd-detect-virt) = "qemu" ]
          set -x QEMU 1
        end
      end
    '';

    functions = {
      fish_greeting = "";

      fish_user_key_bindings = ''
        set -g fish_key_bindings fish_vi_key_bindings

        # Bind Ctrl+z to fg
        bind \cz -M insert 'fg 2>/dev/null; commandline -f repaint'
        bind \cz -M default 'fg 2>/dev/null; commandline -f repaint'
      '';

      mcat = ''
        if file --mime-type $argv | grep -qF image/
            ${lib.getExe pkgs.chafa} -f iterm -s $FZF_PREVIEW_COLUMNS"x"$FZF_PREVIEW_LINES $argv
        else
            ${lib.getExe pkgs.bat} --color always --style numbers --theme TwoDark --line-range :200 $argv
        end'';

      fdz = "${lib.getExe pkgs.fd} --type f --hidden --follow --exclude .git --color=always | ${lib.getExe pkgs.fzf} --ansi --multi --preview='mcat {}'";
    };
  };

  # Copy over my fish functions that aren't managed by Nix
  xdg.configFile =
    with builtins;
    foldl' (acc: path: acc // { "fish/functions/${baseNameOf path}".text = (readFile path); }) { } (
      with lib.fileset; toList (fileFilter (file: file.hasExt "fish") ./functions)
    );
}
