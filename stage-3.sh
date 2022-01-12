
#!/usr/bin/env bash
set -ex

if [ "$EUID" -ne 0 ]
  then echo "Please run as root for mount permissions!"
  exit
fi

nix-shell -p nixUnstable -p git --run "nixos-install --root /mnt --flake .#hetzner"
umount -R /mnt
