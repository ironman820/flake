{
  cell,
  inputs,
  pkgs,
}: {
  home.packages = with pkgs; [
    # barrier
    dia
    # glocom
    qgis
    wireshark
    zoom-us
  ];
}
