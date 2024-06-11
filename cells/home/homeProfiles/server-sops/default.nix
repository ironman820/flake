{
  cell,
  config,
  inputs,
}: {
  sops.secrets = {
    github_home.sopsFile = ./__secrets/servers.yaml;
    github_home_pub.path = "${config.home.homeDirectory}/.ssh/github_home.pub";
    github_servers_pub.path = "${config.home.homeDirectory}/.ssh/github.pub";
    royell_git_work.sopsFile = ./__secrets/servers.yaml;
    royell_git_work_pub.path = "${config.home.homeDirectory}/.ssh/royell_git_work.pub";
    royell_git_servers_pub.path = "${config.home.homeDirectory}/.ssh/royell_git.pub";
  };
}
