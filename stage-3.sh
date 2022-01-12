
#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash tree
set -ex

if [ "$EUID" -ne 0 ]
  then echo "Please run as root for mount permissions!"
  exit
fi


nixos-install --root /mnt --flake .#hetzner
