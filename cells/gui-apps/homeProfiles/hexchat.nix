{
  cell,
  inputs,
}: {
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
}
