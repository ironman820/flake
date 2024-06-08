{
  cell,
  config,
  inputs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  l = nixpkgs.lib // mine.lib // builtins;
  mode = "0400";
  sopsFile = ./__secrets/work-keys.yaml;
in {
  home.packages = [
    nixpkgs.sops
  ];
  sops = {
    age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
    defaultSopsFile = ./__secrets/sops.yaml;
    gnupg.sshKeyPaths = [];
    secrets = l.mkMerge [
      {
        royell_git_servers_pub = {
          inherit mode sopsFile;
          path =
            l.mkDefault
            "${config.home.homeDirectory}/.ssh/royell_git_servers.pub";
        };
        royell_git_work_pub = {
          inherit mode sopsFile;
          path = l.mkDefault "${config.home.homeDirectory}/.ssh/royell_git.pub";
        };
        royell_git_work = {
          inherit mode;
          sopsFile = l.mkDefault sopsFile;
          path = "${config.home.homeDirectory}/.ssh/royell_git";
        };
        yb_keys = {
          inherit mode;
          format = "binary";
          sopsFile = l.mkDefault ./__secrets/yb_keys.sops;
          path = "${config.xdg.configHome}/Yubico/u2f_keys";
        };
      }
    ];
  };
}
