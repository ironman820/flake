{
  cell,
  inputs,
  pkgs,
}: {
  environment.systemPackages = with pkgs; [
    firmware-manager
    gnome-firmware
  ];
  services.fwupd.enable = true;
}
