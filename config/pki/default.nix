let pkiModule = {
  security.pki.certificates = [
    # Channings Principal Certificate Authority Root
    ''
      -----BEGIN CERTIFICATE-----
      MIIByjCCAXGgAwIBAgIQQofn+rGxJXU/EI5Z1irlHzAKBggqhkjOPQQDAjBEMRww
      GgYDVQQKExNDaGFubmluZ3MgUHJpbmNpcGFsMSQwIgYDVQQDExtDaGFubmluZ3Mg
      UHJpbmNpcGFsIFJvb3QgQ0EwHhcNMjUwMTMxMTgyNjUwWhcNMzUwMTI5MTgyNjUw
      WjBEMRwwGgYDVQQKExNDaGFubmluZ3MgUHJpbmNpcGFsMSQwIgYDVQQDExtDaGFu
      bmluZ3MgUHJpbmNpcGFsIFJvb3QgQ0EwWTATBgcqhkjOPQIBBggqhkjOPQMBBwNC
      AARji9/y0detw3pZlmoythdnAUgikjJrU3u1Ty/dXPtyfnfgd9RpRhtdIC5P34JF
      5BXtXhO1ZRK6QcYO8epKkUWco0UwQzAOBgNVHQ8BAf8EBAMCAQYwEgYDVR0TAQH/
      BAgwBgEB/wIBATAdBgNVHQ4EFgQULNjZRx+vQr7P0uHOLnPBzQ+HmGwwCgYIKoZI
      zj0EAwIDRwAwRAIgSCosJwohwbcJkU5t7nQtg/Svrd6gM5Te7kZQaVsOGPkCIHEx
      7v+ZhKQj+ApmSIxkASPYIkonlG4XlZwrfKCCZE1I
      -----END CERTIFICATE-----
    ''
  ];

  programs.ssh.knownHosts = {
    "github.com".publicKey =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
    "channings.me" = {
      certAuthority = true;
      hostNames = [
        "*.lon.channings.me"
        "*.ind.channings.me"
      ];
      publicKey = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBCKpge4As6Hm/pHnr/UKw9VlT0CuU66mJK/WNNh9ooRF2//RdCI5XpP3vBlVOoQF2Nod06xFvBao3THXO+cyEnw=";
    };
  };
};
in
{
  flake.darwinModules.pki = pkiModule;
  flake.nixosModules.pki = pkiModule;
}
