# This is a profile for nixos-containers and should be the bare minimum
# for a service to run
{ self, ... }:
{
  flake.nixosProfiles.container =
    {
      macvlanIface,
      modulesPath,
      pkgs,
      lib,
      config,
      ...
    }:
    {
      system.stateVersion = "24.11";

      imports = [
        (modulesPath + "/profiles/headless.nix")
        (modulesPath + "/profiles/minimal.nix")
        # (modulesPath + "/profiles/perlless.nix")
        self.nixosModules.pki
        self.nixosModules.nixpkgs
        "${self}/modules/nixos/diff-system.nix"
        "${self}/modules/nixos/container-macvlan-network.nix"
        "${self}/modules/nixos/httpd-auth-openidc.nix"
      ];

      disabledModules = [
        (modulesPath + "/profiles/all-hardware.nix")
        (modulesPath + "/profiles/base.nix")
      ];

      nix.enable = lib.mkDefault false;
      nix.channel.enable = lib.mkDefault false;
      system.switch.enable = lib.mkDefault false;
      system.disableInstallerTools = lib.mkDefault true;

      systemd.network.enable = lib.mkDefault true;
      # not compatible with systemd-networkd but enabled
      # in virtualisation/container-config.nix
      networking.useHostResolvConf = false;

      networking.nftables.enable = lib.mkDefault true;

      networking.usePredictableInterfaceNames = lib.mkDefault true;

      boot.kernel.sysctl."net.ipv4.ip_forward" = true;

      services.logrotate.enable = lib.mkForce false;

      services.httpd.virtualHosts.${config.networking.fqdn}.useACMEHost =
        lib.mkDefault config.networking.fqdn;
    };
}
