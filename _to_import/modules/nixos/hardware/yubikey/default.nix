{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.mine) enabled;

  cfg = config.mine.hardware.yubikey;
in {
  options.mine.hardware.yubikey = {
    enable = mkEnableOption "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    mine.gpg = {
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
      settings = {
        cue = true;
        origin = "pam://ironman";
      };
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
