{ pkgs, config, lib, ... }:

with lib;
# with lib.internal;
let
  cfg = config.ironman.default-settings;
in {
  options.ironman.default-settings = with types; {
    enable = mkBoolOpt true "Whether or not to enable a desktop environment.";
  };

  config = mkIf cfg.enable {
    console = {
      font = "Lat2-Terminus16";
      useXkbConfig = true; # use xkbOptions in tty.
    };
    environment.systemPackages = with pkgs; [
      vim
    ];
    i18n.defaultLocale = "en_US.UTF-8";
    location.provider = "geoclue2";
    nix.settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "ironman" ];
    };
    programs.vim.defaultEditor = true;
    services.logind.killUserProcesses = true;
    systemd.extraConfig = ''
      DefaultTimeoutStopSec=10s
    '';
    time.timeZone = "America/Chicago";
  };
}