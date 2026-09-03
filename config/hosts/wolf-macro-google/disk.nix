{ ... }: {
  disko.devices = {
    disk = {
      boot = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
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

      store = {
        type = "disk";
        device = "/dev/nvme1n1";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "rpool";
              };
            };
          };
        };
      };
    };

    zpool = {
      rpool = {
        type = "zpool";
        rootFsOptions = {
          compression = "zstd";
          "com.sun:auto-snapshot" = "false";
        };
        datasets = {
          nix = {
            type = "zfs_fs";
            mountpoint = "/nix";
            options.mountpoint = "legacy";
          };
          home = {
            type = "zfs_fs";
            mountpoint = "/home";
            options.mountpoint = "legacy";
          };
          docker = {
            type = "zfs_fs";
            mountpoint = "/var/lib/docker";
            options.mountpoint = "legacy";
          };
          # /tmp on the pool: the 9G root disk filled twice with scratch data
          # (opencode work dirs, bun caches, tool output). NixOS's tmpfiles rule
          # keeps the mountpoint 1777 on every boot.
          tmp = {
            type = "zfs_fs";
            mountpoint = "/tmp";
            options = {
              mountpoint = "legacy";
              atime = "off";
            };
          };
        };
      };
    };
  };
}
