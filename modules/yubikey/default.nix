{ config, lib, pkgs, system, ... }:

with lib;
let
  cfg = config.ironman.yubikey;
in
{
  options.ironman.yubikey = with types; {
    enable = mkBoolOpt false "Enable the default settings?";
  };

  config = mkIf cfg.enable {
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
    programs = {
      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };
      ssh = {
        enableAskPassword = true;
        startAgent = false;
      };
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
    ironman.home.extraOptions = {
      home.packages = with pkgs; [
        yubioath-flutter
      ];
      programs.gpg = {
        scdaemonSettings = {
          reader-port = "Yubico";
          disable-ccid = true;
          pcsc-shared = true;
        };
      };
    };
  };
}
