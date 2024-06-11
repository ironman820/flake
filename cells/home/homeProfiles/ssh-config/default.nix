{
  cell,
  config,
  inputs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  l = nixpkgs.lib // mine.lib // builtins;
  mode = "0400";
  sopsFile = ./__secrets/keys.yaml;
in {
  programs.ssh = {
    compression = true;
    enable = true;
    forwardAgent = true;
    includes = [
      "~/.ssh/my-config"
    ];
    matchBlocks = {
      "cs1.frm.ryr" = {
        extraOptions = {
          "KexAlgorithms" = "+diffie-hellman-group1-sha1";
          "HostKeyAlgorithms" = "+ssh-dss";
          "Ciphers" = "+3des-cbc";
        };
        hostname = "10.10.183.2";
        user = "royell";
      };
    };
  };
  sops = {
    secrets = {
      deploy_ed25519 = {
        inherit mode sopsFile;
        path = "${config.home.homeDirectory}/.ssh/deploy_ed25519";
      };
      deploy_ed25519_pub = {
        inherit mode sopsFile;
        path = "${config.home.homeDirectory}/.ssh/deploy_ed25519.pub";
      };
      github_home = {
        inherit mode sopsFile;
        path = "${config.home.homeDirectory}/.ssh/github";
      };
      github_home_pub = {
        inherit mode sopsFile;
        path = l.mkDefault "${config.home.homeDirectory}/.ssh/github.pub";
      };
      github_servers_pub = {
        inherit mode sopsFile;
        path =
          l.mkDefault "${config.home.homeDirectory}/.ssh/github_servers.pub";
      };
      github_work_pub = {
        inherit mode sopsFile;
        path = l.mkDefault "${config.home.homeDirectory}/.ssh/github_work.pub";
      };
      id_ed25519_sk = {
        inherit mode sopsFile;
        path = l.mkDefault "${config.home.homeDirectory}/.ssh/id_ed25519_sk";
      };
      id_ed25519_sk_pub = {
        inherit mode sopsFile;
        path =
          l.mkDefault "${config.home.homeDirectory}/.ssh/id_ed25519_sk.pub";
      };
      id_ed25519_sk_work_pub = {
        inherit mode sopsFile;
        path =
          l.mkDefault
          "${config.home.homeDirectory}/.ssh/id_ed25519_sk_work.pub";
      };
      id_ed25519_sk_work2_pub = {
        inherit mode sopsFile;
        path =
          l.mkDefault
          "${config.home.homeDirectory}/.ssh/id_ed25519_sk_work2.pub";
      };
      id_rsa_yubikey_pub = {
        inherit mode sopsFile;
        path =
          l.mkDefault "${config.home.homeDirectory}/.ssh/id_rsa_yubikey.pub";
      };
      my-config = {
        inherit mode;
        format = "binary";
        path = "${config.home.homeDirectory}/.ssh/my-config";
        sopsFile = ./__secrets/my-config.sops;
      };
    };
  };
}
