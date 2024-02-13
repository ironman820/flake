_:
{
  config = {
    home.shellAliases = {
      "s" = "kitten ssh";
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
