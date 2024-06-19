{
  cell,
  config,
  inputs,
}: let
  fPath = "${config.home.homeDirectory}/.ssh";
in {
  sops.secrets = {
    royell_git_work.sopsFile = ./__secrets/servers.yaml;
    royell_git_work_pub.path = "${fPath}/royell_git_work.pub";
    royell_git_servers_pub.path = "${fPath}/royell_git.pub";
  };
}
