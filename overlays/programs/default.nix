{channels, ...}: final: prev: {
  inherit (channels.unstable) feishin;
  inherit (prev.mine) convertToHtmlMultipart idracclient ranger-devicons switchssh tochd urlview;
  inherit (prev.snowfallorg) flake;
}
