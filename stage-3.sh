
#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nixUnstable
set -ex

if [ "$EUID" -ne 0 ]
  then echo "Please run as root for mount permissions!"
  exit
fi

nixos-install --root "$1" --flake .#hetzner
