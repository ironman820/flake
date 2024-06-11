{
  cell,
  inputs,
  pkgs,
}: {
  environment.systemPackages = with pkgs; [
    hplip
    ntfs3g
    wireguard-tools
  ];
}
