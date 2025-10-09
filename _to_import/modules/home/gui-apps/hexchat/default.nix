{
  config,
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.mine) mkBoolOpt;

  cfg = config.mine.home.gui-apps.hexchat;
  os = osConfig.mine.gui-apps.hexchat;
in {
  options.mine.home.gui-apps.hexchat = {
    enable = mkBoolOpt os.enable "Enable the module";
  };
  config = mkIf cfg.enable {
    programs.hexchat = {
      enable = true;
      channels = {
        irchighway = {
          autojoin = ["#ebooks"];
          charset = "UTF-8 (Unicode)";
          options = {
            acceptInvalidSSLCertificates = true;
            autoconnect = true;
            bypassProxy = true;
            forceSSL = false;
          };
          servers = ["irc.irchighway.net"];
        };
      };
      settings = {
        dcc_auto_recv = "2";
        dcc_auto_resume = "1";
      };
    };
  };
}
