{ config, lib, pkgs, system, ... }:

with lib;
with lib.ironman;
let
  cfg = config.ironman.yubikey;
in
{
  options.ironman.yubikey = with types; {
    enable = mkBoolOpt false "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    ironman.gpg = {
      enable = true;
      enableSSHSupport = true;
    };
    environment = {
      shellInit = ''
        gpg-connect-agent /bye
        export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
      '';
      systemPackages = with pkgs; [
        gnupg
        yubikey-personalization
      ];
    };
    hardware.gpgSmartcards = enabled;
    programs.ssh = {
      enableAskPassword = true;
      startAgent = false;
    };
    security.pam.u2f = {
      enable = true;
      cue = true;
      origin = "pam://ironman";
    };
    services = {
      pcscd.enable = true;
      udev.packages = with pkgs; [
        yubikey-personalization
      ];
      yubikey-agent = enabled;
    };
  };
}
