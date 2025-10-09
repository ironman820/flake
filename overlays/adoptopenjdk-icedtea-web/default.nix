{channels, ...}: final: prev: {
  inherit (channels.nixpkgs-acc5f7b) adoptopenjdk-icedtea-web;
}
