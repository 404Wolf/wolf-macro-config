{ ... }: {
  disko.devices.disk.vda = {
    type = "disk";
    device = "/dev/vda";
    content = {
      type = "gpt";
      partitions = {
        bios = {
          size = "1M";
          type = "EF02"; # BIOS boot for GRUB
          priority = 1;
        };
        root = {
          size = "100%";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        };
      };
    };
  };
}
