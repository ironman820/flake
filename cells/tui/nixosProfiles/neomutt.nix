{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mine.tui.neomutt;
in {
  options.mine.tui.neomutt = {
    enable = mkEnableOption "Enable the module";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      abook
      cacert
      curl
      fim
      gettext
      isync
      imapfilter
      khal
      lieer
      lynx
      mutt-wizard
      msmtp
      notmuch
      urlscan
      urlview
      w3m
    ];
  };
}
