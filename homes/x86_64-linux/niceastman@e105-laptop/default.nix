{
  config,
  inputs,
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
    inputs.stylix.homeManagerModules.stylix
  ];
  # home = {packages = with pkgs; [mine.blockyalarm steam-run];};
  home = {packages = with pkgs; [steam-run];};
  mine.home = {
    sops.secrets = {
      github_home = {inherit sopsFile;};
      github_home_pub.path = "${sshFolder}/github_home.pub";
      github_work_pub.path = "${sshFolder}/github.pub";
      id_ed25519_sk = {inherit sopsFile;};
      id_ed25519_sk_work_pub.path = "${sshFolder}/id_ed25519_sk.pub";
      id_ed25519_sk_work2 = {
        inherit sopsFile;
        mode = "0400";
        path = "${sshFolder}/id_ed25519_sk_work2";
      };
      yb_keys.sopsFile = ./secrets/yb_keys.sops;
    };
    glocom = enabled;
    gui-apps.hexchat = true;
    networking = enabled;
    neomutt = {
      enable = true;
      workEmail = true;
    };
    stylix = enabled;
    suites.workstation = enabled;
    ranger = enabled;
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
