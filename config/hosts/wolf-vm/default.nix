{ modulesPath, ... }: {
  imports = [
    "${modulesPath}/profiles/qemu-guest.nix"
    ./disk.nix
    ../../virt.nix
  ];

  networking.hostName = "wolf-macro-vm";

  hardware.graphics.enable = true;

  boot.loader.grub.enable = true;

  swapDevices = [{ device = "/swapfile"; size = 16 * 1024; }];
}
