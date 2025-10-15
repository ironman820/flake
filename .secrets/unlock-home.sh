#! /usr/bin/env sh

mkdir -p ~/.ironman
mkdir -p ~/.config/sops/age

nix-shell -p age --run "age -d -o ~/.config/sops/age/keys.txt keys.txt.age"
nix-shell -p age --run "age -d -o ~/.ironman/personal-email -i ~/.config/sops/age/keys.txt personal-email.age"
nix-shell -p age --run "age -d -o ~/.ironman/work-email -i ~/.config/sops/age/keys.txt work-email.age"
nix-shell -p age --run "age -d -o ~/.ironman/work-email-username -i ~/.config/sops/age/keys.txt work-email-username.age"
