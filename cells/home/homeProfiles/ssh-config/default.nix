{
  cell,
  config,
  inputs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  f = ".ssh";
  l = nixpkgs.lib // mine.lib // builtins;
  mode = "0400";
  sopsFile = ./__secrets/keys.yaml;
in {
  home.file = {
    "${f}/deploy_ed25519.pub".source = ./__files/deploy_ed25519.pub;
    "${f}/github_home.pub".source = ./__files/github_home.pub;
    "${f}/github_servers.pub".source = ./__files/github_servers.pub;
    "${f}/github_work.pub".source = ./__files/github_work.pub;
    "${f}/id_ed25519_sk.pub".source = ./__files/id_ed25519_sk.pub;
    "${f}/id_ed25519_sk_work.pub".source = ./__files/id_ed25519_sk_work.pub;
    "${f}/id_ed25519_sk_work2.pub".source = ./__files/id_ed25519_sk_work2.pub;
    "${f}/id_rsa_yubikey.pub".source = ./__files/id_rsa_yubikey.pub;
  };
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
      github_home = {
        inherit mode sopsFile;
        path = "${config.home.homeDirectory}/.ssh/github";
      };
      id_ed25519_sk = {
        inherit mode sopsFile;
        path = l.mkDefault "${config.home.homeDirectory}/.ssh/id_ed25519_sk";
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
