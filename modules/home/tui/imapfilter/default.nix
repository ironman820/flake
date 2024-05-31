{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (config.mine.home) user;
  inherit (lib) mkEnableOption mkIf mkMerge;

  cfg = config.mine.home.tui.imapfilter;
  configFolder = "${config.xdg.configHome}/imapfilter";
  pwd = "/home/${user.name}/.config/flake/modules/home/tui/imapfilter";
  sopsFile = ./secrets/imapfilter.yaml;
in {
  options.mine.home.tui.imapfilter = {
    enable = mkEnableOption "Enable the module";
    work = mkEnableOption "Enable the work email account";
    home = mkEnableOption "Enable the home account";
  };
  config = mkIf cfg.enable {
    mine.home.sops.secrets = mkMerge [
      (mkIf cfg.work {
        imapfilter_work = {
          inherit sopsFile;
          path = "${configFolder}/work.lua";
        };
        work_accounting_email = {
          inherit sopsFile;
          path = "${configFolder}/work_accounting_email.lua";
        };
        work_cleanup_senders = {
          inherit sopsFile;
          path = "${configFolder}/work_cleanup_senders.lua";
        };
        work_csr_email = {
          inherit sopsFile;
          path = "${configFolder}/work_csr_email.lua";
        };
        work_eset_email = {
          inherit sopsFile;
          path = "${configFolder}/work_eset_email.lua";
        };
        work_my_email = {
          inherit sopsFile;
          path = "${configFolder}/work_my_email.lua";
        };
        work_rhea_email = {
          inherit sopsFile;
          path = "${configFolder}/work_rhea_email.lua";
        };
        work_voip_email = {
          inherit sopsFile;
          path = "${configFolder}/work_voip_email.lua";
        };
      })
      (mkIf cfg.home {
        imapfilter_home = {
          inherit sopsFile;
          path = "${configFolder}/home.lua";
        };
      })
    ];
    home.shellAliases.imapfilter = "imapfilter -c \"${configFolder}/config.lua\"";
    # Moved to neomutt config
    # systemd.user = {
    #   services."imapfilter" = {
    #     Unit.Description = "Run IMAPFilter in the background.";
    #     Install.WantedBy = ["default.target"];
    #     Service.ExecStart = "${pkgs.imapfilter}/bin/imapfilter -c \"${configFolder}/config.lua\"";
    #   };
    #   timers."imapfilter" = {
    #     Install.WantedBy = ["timers.target"];
    #     Timer.OnCalendar = "*:0/5";
    #   };
    # };
    xdg.configFile = {
      "imapfilter/cleanuphome.lua".source = mkOutOfStoreSymlink "${pwd}/config/cleanuphome.lua";
      "imapfilter/cleanupwork.lua".source = mkOutOfStoreSymlink "${pwd}/config/cleanupwork.lua";
      "imapfilter/config.lua".source = mkOutOfStoreSymlink "${pwd}/config/config.lua";
      "imapfilter/utilities.lua".source = mkOutOfStoreSymlink "${pwd}/config/utilities.lua";
      "imapfilter/home.lua" = mkIf (!cfg.home) {
        text = ''
          return nil
        '';
      };
      "imapfilter/work.lua" = mkIf (!cfg.work) {
        text = ''
          return nil
        '';
      };
    };
  };
}
