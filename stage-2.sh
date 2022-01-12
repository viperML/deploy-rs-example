#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash gptfdisk util-linux btrfs-progs
set -ex

if [ "$EUID" -ne 0 ]
  then echo "Please run as root for mount permissions!"
  exit
fi

MNT="/mnt"
BTRFS_OPTS="compress=zstd,noatime"
TARGET="$1"

sgdisk --zap-all "${TARGET}"
sgdisk -a1 -n1:2048:4095 -t1:EF02 "${TARGET}"
sgdisk     -n2:0:0       -t2:8300 "${TARGET}"

fdisk -l "${TARGET}"

mkfs.btrfs -f -L NIXOS "${TARGET}-part2"

mkdir -p "${MNT}"
umount -R "${MNT}" || :
mount "${TARGET}-part2" "${MNT}"
btrfs subvolume create "${MNT}"/@rootfs
btrfs subvolume create "${MNT}"/@nix
btrfs subvolume create "${MNT}"/@boot
btrfs subvolume create "${MNT}"/@swap
umount "${MNT}"

mount -o "$BTRFS_OPTS,subvol=@rootfs" "${TARGET}-part2" "${MNT}"
mkdir "${MNT}"/{nix,boot,swap}
mount -o "$BTRFS_OPTS,subvol=@nix" "${TARGET}-part2" "${MNT}"/nix
mount -o "$BTRFS_OPTS,subvol=@swap" "${TARGET}-part2" "${MNT}"/swap
mount -o "$BTRFS_OPTS,subvol=@boot" "${TARGET}-part2" "${MNT}"/boot

findmnt -R --target "${MNT}"
