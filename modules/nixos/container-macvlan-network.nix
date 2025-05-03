# extraArguments:
#   - macvlanIface: The name of the host's macvlan interface
{
  macvlanIface,
  lib,
  pkgs,
  config,
  ...
}:
{
  config = lib.mkIf (macvlanIface != null) {
    assertions = [
      {
        assertion = config.systemd.network.enable;
        message = "systemd-networkd must be enabled to use container-macvlan-network";
      }
    ];
    systemd.services.ethtool-disable-offloading = {
      description = "ethtool-disable-hw-offloading";
      script = ''
        ${lib.getExe pkgs.ethtool} -K vlan0 gro off gso off tso off tx off rx off
        ${lib.getExe pkgs.ethtool} -K ${macvlanIface} gro off gso off tso off tx off rx off
        echo "Done"
      '';
      serviceConfig = {
        Type = "oneshot";
        User = "root";
      };
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
    };

    systemd.network = {
      netdevs = {
        "20-vlan0" = {
          netdevConfig = {
            Kind = "vlan";
            Name = "vlan0";
          };
          vlanConfig.Id = 40;
        };
      };

      networks = {
        "30-${macvlanIface}" = {
          matchConfig.Name = macvlanIface;
          vlan = [ "vlan0" ];
          networkConfig.DHCP = "no";
          networkConfig.LinkLocalAddressing = "no";
          linkConfig.RequiredForOnline = "carrier";
        };
        "40-vlan0" = {
          matchConfig.Name = "vlan0";
          networkConfig.UseDomains = "yes";
          networkConfig.DHCP = "yes";
          linkConfig.RequiredForOnline = "routable";
          dhcpV4Config.ClientIdentifier = "mac";
        };
      };
    };
  };
}
