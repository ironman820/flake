{ channels, ... }:
final: prev:
{
  # final.openvpn = openvpn.override { openssl = prev.openssl_1_1; };
  networkmanager-openvpn = prev.networkmanager-openvpn.override {
    openvpn = prev.openvpn.override {
      openssl = prev.openssl_1_1;
    };
  };
}
