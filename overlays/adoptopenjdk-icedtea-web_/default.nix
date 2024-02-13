{ channels, ... }:
final: prev:
{
  inherit (channels.nixpkgs-acc5f7b) adoptopenjdk-icedtea-web;
  # newIcedTea = prev.adoptopenjdk-icedtea-web.overrideAttrs (_: {
  #   # jdk = channels.nixpkgs.oraclejdk8;
  #   # jdk = channels.nixpkgs.zulu8;
  # });
  # myIcedTea = channels.nixpkgs.newIcedTea.override {
  #   # jdk = channels.nixpkgs.oraclejdk8;
  # };
}
