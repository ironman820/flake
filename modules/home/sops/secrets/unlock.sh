#! /usr/bin/env sh

mkdir -p ~/.config/sops/age

nix-shell -p age --run "age --decrypt --output ~/.config/sops/age/keys.txt keys.txt.age"
