#! /usr/bin/env sh

nix-shell -p age --run "age --decrypt --output /etc/nixos/keys.txt keys.txt.age"
