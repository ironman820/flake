#! /usr/bin/env sh

mkdir -p ~/.config/sops/age

if [[ "$1" -ne "w" ]]; then
  nix-shell -p age --run "age -d -o ~/.config/sops/age/keys.txt keys.txt.age"
else
  nix-shell -p age --run "age -d -o ~/.config/sops/age/keys.txt keys-work.txt.age"
fi

