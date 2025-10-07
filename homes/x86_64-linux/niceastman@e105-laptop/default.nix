{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.mine) enabled;
  sopsFile = ./secrets/work-keys.yaml;
  sshFolder = "${config.home.homeDirectory}/.ssh";
in {
  imports = [
    ../modules.nix
  ];
  # home = {packages = with pkgs; [mine.blockyalarm steam-run];};
  mine.home = {
    sops.secrets.yb_keys.sopsFile = ./secrets/yb_keys.sops;
    gui-apps.glocom = enabled;
    suites.workstation = enabled;
    tui.neomutt = {
      notmuchWork = true;
      workEmail = true;
    };
    user.settings.stylix.image = ../../../systems/x86_64-linux/e105-laptop/voidbringer.png;
    work-tools = enabled;
  };
  # systemd.user = {
  #   services."leave" = {
  #     Unit.Description = "blockyalarm Go Home";
  #     Install.WantedBy = [ "default.target" ];
  #     Service.ExecStart = ''${pkgs.mine.blockyalarm}/bin/blockyalarm "Get out of the office!"'';
  #   };
  #   timers."leave" = {
  #     Install.WantedBy = [ "timers.target" ];
  #     Timer.OnCalendar = "Mon..Fri 17:00,15:00";
  #   };
  # };
}
