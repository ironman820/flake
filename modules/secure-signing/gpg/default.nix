{ pkgs, config, lib, ... }:

with lib;
let
  cfg = config.ironman.secure-signing.gpg;
in {
  options.ironman.secure-signing.gpg = with types; {
    enable = mkBoolOpt true "Whether or not to enable Gnome.";
  };

  config = mkIf cfg.enable {
    environment = {
      shellInit = ''
        gpg-connect-agent /bye
        export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
      '';
      systemPackages = [ pkgs.gnupg ];
    };
    programs = {
      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };
      ssh.startAgent = false;
    };
  };
}