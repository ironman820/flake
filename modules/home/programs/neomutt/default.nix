{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkMerge;
  inherit (lib.ironman) enabled;

  cfg = config.ironman.home.programs.neomutt;
  configFolder = "${config.xdg.configHome}/mutt";
in {
  options.ironman.home.programs.neomutt = {
    enable = mkEnableOption "Install Neomutt";
    personalEmail = mkEnableOption "Setup Personal Email";
    workEmail = mkEnableOption "Setup Work Email";
  };

  config = mkIf cfg.enable (let
    sopsFile = ./secrets/neomutt.yaml;
  in {
    ironman.home.sops.secrets = mkMerge [
      {
        "mbsync" = {
          inherit sopsFile;
          path = "${config.home.homeDirectory}/.mbsyncrc";
        };
        "msmtp_config" = {
          inherit sopsFile;
          path = "${config.xdg.configHome}/msmtp/config";
        };
        "notmuch-config" = {
          inherit sopsFile;
          path = "${config.home.homeDirectory}/.notmuch-config";
        };
        "work_sig" = {
          inherit sopsFile;
          path = "${configFolder}/signatures/work.sig";
        };
        "personal_sig" = {
          inherit sopsFile;
          path = "${configFolder}/signatures/personal.sig";
        };
      }
      (mkIf cfg.personalEmail {
        "muttrc_personal_email" = {
          inherit sopsFile;
          path = "${configFolder}/accounts/master.muttrc";
        };
        "muttrc_work_email" = {
          inherit sopsFile;
          path = "${configFolder}/accounts/work.muttrc";
        };
      })
      (mkIf cfg.workEmail {
        "muttrc_work_email" = {
          inherit sopsFile;
          path = "${configFolder}/accounts/master.muttrc";
        };
        "muttrc_personal_email" = {
          inherit sopsFile;
          path = "${configFolder}/accounts/personal.muttrc";
        };
      })
    ];
    home = {
      packages = with pkgs; [
        abook
        browsh
        cacert
        curl
        fim
        gettext
        isync
        khal
        lieer
        lynx
        mutt-wizard
        msmtp
        notmuch
        pass
        urlview
      ];
      shellAliases = {mail = "neomutt";};
    };
    programs.neomutt = enabled;
    xdg.configFile = {
      "mutt/mailcap".text = ''
        text/csv; ${pkgs.libreoffice-fresh}/lib/libreoffice/program/soffice %s ;
        text/plain; $EDITOR %s ;
        text/html; lynx -assume_charset=%{charset} -display_charset=utf-8 -dump -width=1024 %s; nametemplate=%s.html; copiousoutput;
        text/html; ${pkgs.mutt-wizard}/lib/mutt-wizard/openfile %s ; nametemplate=%s.html
        image/*; fim %s ;
        image/*; ${pkgs.mutt-wizard}/lib/mutt-wizard/openfile %s ;
        video/*; setsid mpv --quiet %s &; copiousoutput
        audio/*; vlc %s ;
        application/pdf; zathura %s ;
        application/pdf; ${pkgs.mutt-wizard}/lib/mutt-wizard/openfile %s ;
        application/pgp-encrypted; gpg -d '%s'; copiousoutput;
        application/pgp-keys; gpg --import '%s'; copiousoutput;
        application/vnd.openxmlformats-officedocument.spreadsheetml.sheet; ${pkgs.libreoffice-fresh}/lib/libreoffice/program/soffice %s ;
      '';
      "mutt/muttrc".source = ./muttrc;
      "mutt/mutt-wizard.muttrc".source = ./mutt-wizard.muttrc;
      "mutt/personal.mailboxes".source = ./personal.mailboxes;
      "mutt/switch.muttrc".source = ./switch.muttrc;
      "mutt/theme".source = "${pkgs.catppuccin-neomutt}/catppuccin-neomutt";
      "mutt/work.mailboxes".source = ./work.mailboxes;
    };
  });
}
