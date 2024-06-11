{
  cell,
  inputs,
  pkgs,
}: {
  environment.systemPackages = with pkgs; [
    hexchat
  ];
}
