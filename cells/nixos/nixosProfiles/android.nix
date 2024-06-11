{
  cell,
  config,
  inputs,
  pkgs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  l = nixpkgs.lib // mine.lib // builtins;
  p = mine.packages;
  v = config.vars;
in {
  users.users.${v.username}.extraGroups = ["adbusers"];
  environment.systemPackages = with pkgs; [
    android-studio
    p.open-android-backup
  ];
  programs.adb = l.enabled;
  services.udev.packages = [
    pkgs.android-udev-rules
  ];
}
