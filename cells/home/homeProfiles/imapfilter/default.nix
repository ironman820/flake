{
  cell,
  config,
  inputs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  c = config.vars.imapfilter;
  configFolder = "${config.xdg.configHome}/imapfilter";
  l = nixpkgs.lib // mine.lib // builtins;
  # lf = config.lib.file;
  # pwd = "${config.xdg.configHome}/flake/cells/home/homeProfiles/imapfilter";
  sopsFile = ./__secrets/imapfilter.yaml;
in {
  options.vars.imapfilter = {
    work = l.mkEnableOption "Enable the work email account";
    home = l.mkEnableOption "Enable the home account";
  };
  config = {
    sops.secrets = l.mkMerge [
      (l.mkIf c.work {
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
      (l.mkIf c.home {
        imapfilter_home = {
          inherit sopsFile;
          path = "${configFolder}/home.lua";
        };
      })
    ];
    home.shellAliases.imapfilter = "imapfilter -c \"${configFolder}/config.lua\"";
    xdg.configFile = {
      # These following lines for testing
      # "imapfilter/cleanuphome.lua".source = lf.mkOutOfStoreSymlink "${pwd}/config/cleanuphome.lua";
      # "imapfilter/cleanupwork.lua".source = lf.mkOutOfStoreSymlink "${pwd}/config/cleanupwork.lua";
      # "imapfilter/config.lua".source = lf.mkOutOfStoreSymlink "${pwd}/config/config.lua";
      # "imapfilter/utilities.lua".source = lf.mkOutOfStoreSymlink "${pwd}/config/utilities.lua";

      # These lines are for production
      "imapfilter/cleanuphome.lua".source = ./__config/cleanuphome.lua;
      "imapfilter/cleanupwork.lua".source = ./__config/cleanupwork.lua;
      "imapfilter/config.lua".source = ./__config/config.lua;
      "imapfilter/utilities.lua".source = ./__config/utilities.lua;

      "imapfilter/home.lua" = l.mkIf (!c.home) {
        text = ''
          return nil
        '';
      };
      "imapfilter/work.lua" = l.mkIf (!c.work) {
        text = ''
          return nil
        '';
      };
    };
  };
}
