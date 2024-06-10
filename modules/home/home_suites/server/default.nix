{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.home.suites.server;
in {
  options.mine.home.suites.server = {
    enable = mkEnableOption "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    mine.home = {
      sops.secrets = {
        github_home.sopsFile = ./secrets/servers.yaml;
        github_home_pub.path = "${config.home.homeDirectory}/.ssh/github_home.pub";
        github_servers_pub.path = "${config.home.homeDirectory}/.ssh/github.pub";
        royell_git_work.sopsFile = ./secrets/servers.yaml;
        royell_git_work_pub.path = "${config.home.homeDirectory}/.ssh/royell_git_work.pub";
        royell_git_servers_pub.path = "${config.home.homeDirectory}/.ssh/royell_git.pub";
      };
    };
  };
}
