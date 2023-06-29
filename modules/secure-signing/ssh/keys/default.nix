{ pkgs, config, lib, ... }:

with lib;
let
  cfg = config.ironman.secure-signing.ssh;
in {
  config.ironman.home.file = mkIf cfg.enable {
    ".ssh/id_ed25519_sk.pub".source = ./id_ed25519_sk.pub;
    ".ssh/id_ed25519_sk_work.pub".source = ./id_ed25519_sk_work.pub;
    ".ssh/github_home.pub".source = ./github_home.pub;
    ".ssh/id_rsa_yubikey.pub".source = ./id_rsa_yubikey.pub;
  };
}