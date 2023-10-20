{ channels, ... }:
final: prev:
let
  inherit (channels.nixpkgs-22-05) openvpn;
in
{
  final.openvpn = openvpn.override { openssl = prev.openssl_1_1; };
}
