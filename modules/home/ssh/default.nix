{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  imp = config.mine.home.impermanence.enable;
in {
  config = {
    home = {
      persistence."/persist/home".directories = mkIf imp [
        ".ssh"
      ];
      shellAliases = {
        "s" = "kitten ssh";
      };
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
  };
}
