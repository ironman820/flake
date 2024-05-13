#!/usr/bin/env bash

# Create a temporary directory
temp=$(mktemp -d)
flake=$1
ip=$2
user=$3

# Function to cleanup temporary directory on exit
cleanup() {
  rm -rf "$temp"
}
trap cleanup EXIT

# Create the directory where sshd expects to find the host keys
install -d -m755 "$temp/etc/nixos"
install -d -m755 "$temp/home/$user/.config/sops/age"

# Decrypt your private key from the password store and copy it to the temporary directory
cp /etc/nixos/keys.txt "$temp/etc/nixos/"
cp /etc/nixos/keys.txt "$temp/home/$user/.config/sops/age/"
cp -r "$PWD/" "$temp/home/$user/.config/"

# Set the correct permissions so sshd will accept the key
chown -R $(whoami):users "$temp/home/$user"
chmod 644 "$temp/etc/nixos/keys.txt"
chmod 644 "$temp/home/$user/.config/sops/age/keys.txt"

# Install NixOS to the host system with our secrets
nix run github:nix-community/nixos-anywhere -- --extra-files "$temp" --flake "$flake" root@$ip
