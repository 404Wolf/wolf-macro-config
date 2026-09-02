{ ... }: {
  imports = [
    ./disk.nix
    ../../virt.nix
  ];

  networking.hostName = "wolf-macro-google";
  networking.hostId = "f2cda54d"; # required by ZFS

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;

  # This box has a public GCP IP on ens3; only tailscale0 should be reachable.
  services.openssh.openFirewall = false;
  networking.firewall.trustedInterfaces = [ "tailscale0" ];
}
