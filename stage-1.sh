#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash tree

tree /dev/disk/by-path

echo " "
echo "Once you know your disk, run:"
echo "# ./stage-2.sh /dev/disk/by-path/<your disk>"
echo "And after that:"
echo "# ./stage-3.sh"
