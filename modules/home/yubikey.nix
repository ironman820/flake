{
  flake.homeModules.yubikey =
    {
      config,
      flakeRoot,
      ...
    }:
    {
      programs.gpg = {
        scdaemonSettings = {
          reader-port = "Yubico";
          disable-ccid = true;
          pcsc-shared = true;
        };
      };
      sops.secrets.yb_keys = {
        mode = "0400";
        format = "binary";
        sopsFile = flakeRoot + "/.secrets/yb_keys.sops";
        path = "${config.xdg.configHome}/Yubico/u2f_keys";
      };
    };
}
