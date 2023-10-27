{ channels, ... }:
final: prev:
{
  networkmanagerapplet = prev.networkmanagerapplet.override {
    libnma = prev.libnma-gtk4;
  };
}
