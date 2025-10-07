{
  config,
  ...
}:
let
  sopsFile = ./files/keys.yaml;
  mode = "0400";
  sshPath = "${config.home.homeDirectory}/.ssh";
  deployIdentity = {
    identitiesOnly = true;
    identityFile = "${sshPath}/deploy_ed25519";
  };
in
{
  config = {
    home = {
      file = {
        ".ssh/deploy_ed25519.pub".source = ./files/deploy_ed25519.pub;
        ".ssh/github_home.pub".source = ./files/github_home.pub;
        ".ssh/github_servers.pub".source = ./files/github_servers.pub;
        ".ssh/github_work.pub".source = ./files/github_work.pub;
        ".ssh/id_rsa_yubikey.pub".source = ./files/id_rsa_yubikey.pub;
        ".ssh/royell_git_servers.pub".source = ./files/royell_git_servers.pub;
        ".ssh/royell_git_work.pub".source = ./files/royell_git_work.pub;
      };
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
        "billmax" = {
          hostname = "billing.royell.org";
          user = "royell";
        }
        // deployIdentity;
        "billmax2" = {
          hostname = "billing2.royell.org";
          # HostKeyAlgorithms +ssh-rsa
          user = "royell";
        }
        // deployIdentity;
        "cr1" = {
          hostname = "162.216.110.106";
          user = "royell";
        };
        "er1" = {
          hostname = "162.216.110.104";
          user = "royell";
        };
        "er1.crvl" = {
          hostname = "162.216.110.8";
          user = "royell";
        };
        "meet" = {
          hostname = "meet.royell.org";
          user = "royell";
        }
        // deployIdentity;
        "pay" = {
          user = "royell";
        }
        // deployIdentity;
        "preseem" = {
          hostname = "208.80.144.36";
          user = "root";
        }
        // deployIdentity;
      };
    };
    mine.home.sops.secrets = {
      deploy_ed25519 = {
        inherit mode sopsFile;
        path = "${sshPath}/deploy_ed25519";
      };
      github = {
        inherit mode sopsFile;
        path = "${sshPath}/github";
      };
      my-config = {
        inherit mode;
        format = "binary";
        sopsFile = ./files/my-config.sops;
        path = "${sshPath}/my-config";
      };
      royell_git = {
        inherit mode sopsFile;
        path = "${sshPath}/royell_git";
      };
    };
  };
}
