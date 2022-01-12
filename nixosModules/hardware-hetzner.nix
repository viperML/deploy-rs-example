{ config, pkgs, modulesPath, ... }:

{
  networking.networkmanager.enable = true;

  boot = {
    initrd = {
      availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "sd_mod" "sr_mod" ];
      kernelModules = [ ];
    };
    kernelModules = [ ];
    extraModulePackages = [ ];
    loader.grub = {
      enable = true;
      device = "/dev/sda";
    };
  };

  fileSystems."/" =
    {
      device = "/dev/disk/by-label/NIXOS";
      fsType = "btrfs";
      options = [ "subvol=@rootfs" "noatime" "compress=zstd" ];
    };

  fileSystems."/nix" =
    {
      device = "/dev/disk/by-label/NIXOS";
      fsType = "btrfs";
      options = [ "subvol=@nix" "noatime" "compress=zstd" ];
    };


  fileSystems."/boot" =
    {
      device = "/dev/disk/by-label/NIXOS";
      fsType = "btrfs";
      options = [ "subvol=@boot" "noatime" "compress=zstd" ];
    };

  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];
}
