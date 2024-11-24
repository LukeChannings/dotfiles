{ lib, config, ... }:
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
        fish_default_key_bindings -M insert

        fish_vi_key_bindings --no-erase insert
      '';

      mcat = ''
        if file --mime-type $argv | grep -qF image/
            chafa -f iterm -s $FZF_PREVIEW_COLUMNS"x"$FZF_PREVIEW_LINES $argv
        else
            bat --color always --style numbers --theme TwoDark --line-range :200 $argv
        end'';

      fdz = "fd --type f --hidden --follow --exclude .git --color=always | fzf --ansi --multi --preview='mcat {}'";
    };
  };

  # Copy over my fish functions that aren't managed by Nix
  xdg.configFile =
    with builtins;
    foldl' (acc: path: acc // { "fish/functions/${baseNameOf path}".text = (readFile path); }) { } (
      with lib.fileset; toList (fileFilter (file: file.hasExt "fish") ./functions)
    );
}
