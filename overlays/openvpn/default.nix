{ channels, ... }:
final: prev:
{
  openvpn = prev.openvpn.override { openssl = prev.openssl_1_1; };
}
