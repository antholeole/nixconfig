{ lib, ... }:
let
  btrfs-options = [ "compress=zstd" "noatime" ];
in
{
  disko.devices = {
    disk = {
      my-disk = {
        device = "/dev/sda";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              size = "512M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            swap = {
               size = "8G"; # Or your desired swap size
               content = {
                 type = "swap";
               };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";
                settings = {
                  allowDiscards = true;
                };
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  subvolumes = {
                    "@root" = {
                      mountpoint = "/";
                      mountOptions = btrfs-options;
                    };
                    "@nix" = {
                      mountpoint = "/nix";
                      mountOptions = btrfs-options;
                    };
                    "@home" = {
                      mountpoint = "/home";
                      mountOptions = btrfs-options;
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };

  # Enable BTRFS support in the initrd
  boot.initrd.kernelModules = [ "btrfs" ];
  boot.supportedFilesystems = [ "btrfs" ];
}
