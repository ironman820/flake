{ pkgs, config, lib, ... }:
{
  imports = [
    ./hardware.nix
  ];

  environment = {
    systemPackages = (with pkgs; [
      # glocom
    ]);
  };

  ironman = {
    boot.grub-efi.enable = true;
    development = {
      enable = true;
      vscode.enable = true;
    };
    hardware.video.intel-915.enable = true;
    networking.wireless.enable = true;
    virtualisation.distrobox.enable = true;
    virtualisation.podman.compose = true;
    virtualisation.qemu.enable = true;
  };

  system.stateVersion = "23.05";
}