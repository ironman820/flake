{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  imp = config.mine.home.impermanence;
in {
  config = {
    home.shellAliases = {
      "s" = "kitten ssh";
    };
    mine.home.impermanence.files = mkIf imp.enable [
      ".ssh/known_hosts"
      ".ssh/known_hosts.old"
    ];
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
  };
}
