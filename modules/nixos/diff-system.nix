# Shows version differences between the previous and current system generations.
{ config, lib, ... }:
{
  system.activationScripts.diff = ''
    if [[ -e /run/current-system ]]; then
      echo "=== DIFF ==="
      ${lib.getExe config.nix.package} store diff-closures /run/current-system "$systemConfig"
    fi
  '';
}
