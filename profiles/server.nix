{
  flake.nixosProfiles.server =
    {
      modulesPath,
      pkgs,
      lib,
      ...
    }:
    {
      imports = [
        (modulesPath + "/profiles/headless.nix")
      ];

      disabledModules = [
        (modulesPath + "/profiles/all-hardware.nix")
        (modulesPath + "/profiles/base.nix")
      ];

      environment.defaultPackages = [ ];
      environment.systemPackages = with pkgs; [
        # ghostty.terminfo
        wezterm.terminfo
        fd
        lsof

        rsync
        dig
        curl
        jq

        usbutils
        pciutils
        ethtool

        step-cli
      ];

      nixpkgs.overlays = [
        (final: prev: { formats = final.latest.formats; })
      ];

      # Disable sudo requiring a password to enable automation
      # I also don't think this is a security risk since this
      # mostly mitigates an opportunistic attack vector where the
      # shell is left logged in.
      security.sudo.wheelNeedsPassword = false;

      security.polkit.enable = true;

      programs.nano.enable = false;
      programs.vim.enable = true;
      programs.vim.defaultEditor = true;
      programs.fish.enable = true;
      programs.fish.package = pkgs.latest.fish;

      # https://www.psc.edu/hpn-ssh-home/
      # Enable HPN-SSH from PSC
      # Patches SSH with optimisations for long network paths.
      programs.ssh.package = pkgs.openssh_hpn;

      fonts.fontconfig.enable = false;

      xdg.icons.enable = false;
      xdg.mime.enable = false;
      xdg.sounds.enable = false;

      systemd.network.enable = lib.mkDefault true;

      # This is managed by systemd-networkd
      networking.useDHCP = lib.mkDefault false;

      networking.nftables.enable = lib.mkDefault true;
      networking.usePredictableInterfaceNames = lib.mkDefault true;

      boot.kernel.sysctl."net.ipv4.ip_forward" = true;

      services.resolved.extraConfig = ''
        DNSStubListener=no
        Cache=no
      '';
      services.sshd.enable = true;
      services.timesyncd.enable = true;

      # Enable mDNS for local network discovery
      services.avahi.enable = true;
      services.avahi.openFirewall = true;
      services.avahi.nssmdns4 = true;
      services.avahi.publish.enable = true;
      services.avahi.publish.domain = true;
      services.avahi.publish.addresses = true;

      boot.supportedFilesystems.ext4 = true;
    };
}
