{
  flake.homeModules.ssh =
    {
      config,
      flakeRoot,
      ...
    }:
    let
      configFiles = flakeRoot + "/.config/git";
      sopsFile = flakeRoot + "/.secrets/ssh-keys.yaml";
      mode = "0400";
      sshPath = "${config.home.homeDirectory}/.ssh";
      deployIdentity = {
        identitiesOnly = true;
        identityFile = "${sshPath}/deploy_ed25519";
      };
      switchSSH = {
        user = "royell";
        extraOptions = {
          "KexAlgorithms" = "+diffie-hellman-group1-sha1";
          "Ciphers" = "+3des-cbc";
        };
      };
    in
    {
      home = {
        file = {
          ".ssh/deploy_ed25519.pub".source = configFiles + "/deploy_ed25519.pub";
          ".ssh/github_home.pub".source = configFiles + "/github_home.pub";
          ".ssh/github_servers.pub".source = configFiles + "/github_servers.pub";
          ".ssh/github_work.pub".source = configFiles + "/github_work.pub";
          ".ssh/id_rsa_yubikey.pub".source = configFiles + "/id_rsa_yubikey.pub";
          ".ssh/royell_git_servers.pub".source = configFiles + "/royell_git_servers.pub";
          ".ssh/royell_git_work.pub".source = configFiles + "/royell_git_work.pub";
        };
        shellAliases = {
          "s" = "kitten ssh";
        };
      };
      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        matchBlocks = {
          "*" = {
            compression = true;
            forwardAgent = true;
            addKeysToAgent = "no";
            serverAliveInterval = 0;
            serverAliveCountMax = 3;
            hashKnownHosts = false;
            userKnownHostsFile = "${sshPath}/known_hosts";
            controlMaster = "no";
            controlPath = "${sshPath}/master-%r@%n:%p";
            controlPersist = "no";
          };
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
          "10.10.50.10" = {
            user = "root";
            port = 923;
          };
          "10.10.240.3" = {
          }
          // switchSSH;
          "10.105.20.2" = {
          }
          // switchSSH;
          "alerts" = {
            hostname = "alerts.royell.org";
            user = "royell";
          }
          // deployIdentity;
          "auth" = {
            hostname = "auth.royell.org";
            user = "niceastman";
          }
          // deployIdentity;
          "auth.home" = {
            hostname = "192.168.248.38";
            user = "root";
          }
          // deployIdentity;
          "backup" = {
            hostname = "208.80.144.49";
            user = "root";
          };
          "calix-shelf" = {
            hostname = "10.31.3.14";
          }
          // switchSSH;
          "cameras" = {
            hostname = "208.80.144.63";
            user = "royell";
          }
          // deployIdentity;
          "cpanel" = {
            hostname = "wns1.royell.org";
            user = "root";
          }
          // deployIdentity;
          "cr1.fb.aub" = {
            hostname = "162.216.110.49";
            user = "royell";
          };
          "cs1" = {
            hostname = "100.64.0.18";
            user = "royell";
          };
          "cs1.cstr.mm" = {
            hostname = "10.10.36.2";
          }
          // switchSSH;
          "cs1.igr.nbrln" = {
            hostname = "10.10.51.2";
          }
          // switchSSH;
          "cs1.irvg.mm" = {
            hostname = "10.10.177.3";
          }
          // switchSSH;
          "cs1.ltfld.mm" = {
            hostname = "172.29.132.2";
          }
          // switchSSH;
          "cs1.mm.gir" = {
            hostname = "10.10.200.2";
          }
          // switchSSH;
          "cs1.mm.vrdn" = {
            hostname = "172.29.129.2";
          }
          // switchSSH;
          "cs1.wav.190" = {
            hostname = "100.64.0.6";
          }
          // switchSSH;
          "cs1.twr.wvry" = {
            hostname = "10.10.213.2";
          }
          // switchSSH;
          "cs2.twr.wvry" = {
            hostname = "10.10.49.2";
          }
          // switchSSH;
          "cs1.vrdn.wt" = {
            hostname = "100.64.0.66";
          }
          // switchSSH;
          "cs1.wt.fkln" = {
            hostname = "10.10.208.2";
          }
          // switchSSH;
          "cs2" = {
            hostname = "100.64.0.19";
            user = "royell";
          };
          "cs3.mm.crvl" = {
            hostname = "100.64.0.36";
          }
          // switchSSH;
          "dhcp" = {
            hostname = "208.91.182.74";
            extraOptions."HostKeyAlgorithms" = "+ssh-rsa";
            port = 8222;
            user = "root";
          };
          "dhcp.desk" = {
            hostname = "192.168.21.4";
            user = "root";
          }
          // deployIdentity;
          "dns1" = {
            hostname = "dns1.royell.org";
            user = "root";
          };
          "dns2" = {
            hostname = "dns2.royell.org";
            user = "root";
          };
          "dns.desk" = {
            hostname = "192.168.20.2";
            user = "ironman";
          }
          // deployIdentity;
          "docker" = {
            hostname = "docker.royell.org";
            user = "royell";
          };
          "docker2" = {
            hostname = "208.80.144.53";
            user = "royell";
          };
          "docker.desk" = {
            hostname = "192.168.20.11";
            user = "ironman";
          }
          // deployIdentity;
          "friday" = {
            hostname = "192.168.254.215";
            user = "ironman";
          }
          // deployIdentity;
          "cs1.mf.gir" = {
            hostname = "10.10.240.3";
            user = "royell";
          };
          "git.royell.org" = {
            hostname = "git.royell.org";
            identitiesOnly = true;
            identityFile = "${sshPath}/royell_git";
          };
          "github.com" = {
            identitiesOnly = true;
            identityFile = "${sshPath}/github";
          };
          "google" = {
            hostname = "google.royell.co";
            user = "royell";
          }
          // deployIdentity;
          "guacamole.desk" = {
            hostname = "192.168.20.7";
          };
          "health" = {
            hostname = "health.royell.org";
            user = "royell";
          };
          "home-netbox" = {
            hostname = "192.168.253.3";
            user = "ironman";
          };
          "k8-1" = {
            hostname = "192.168.21.9";
            user = "royell";
          };
          "k8-2" = {
            hostname = "192.168.21.10";
            user = "royell";
          };
          "k8-3" = {
            hostname = "192.168.21.11";
            user = "royell";
          };
          "llama" = {
            hostname = "192.168.248.120";
            user = "ironman";
          } // deployIdentity;
          "mail" = {
            hostname = "webmail.royell.org";
            user = "royell";
          }
          // deployIdentity;
          "mail2" = {
            hostname = "208.80.144.31";
            user = "royell";
          };
          "massmail" = {
            hostname = "208.80.144.64";
            user = "royell";
          }
          // deployIdentity;
          "mysql" = {
            hostname = "mysql.royell.org";
            user = "royell";
          };
          "mysql2" = {
            hostname = "mysql2.royell.org";
            user = "royell";
          };
          "mysql.home" = {
            hostname = "192.168.253.5";
            user = "ironman";
          };
          "netbox" = {
            hostname = "netbox.royell.org";
            user = "root";
          };
          "netmon" = {
            hostname = "netmon.royell.org";
            user = "root";
          };
          "nokia" = {
            hostname = "nokia.royell.org";
            user = "royell";
          };
          "nokia2" = {
            hostname = "nokia2.royell.org";
            user = "royell";
          };
          "observium" = {
            hostname = "observium.royell.org";
            user = "root";
          }
          // deployIdentity;
          "omv" = {
            hostname = "192.168.248.5";
            user = "ironman";
          }
          // deployIdentity;
          "pass.royell" = {
            hostname = "208.80.144.66";
            user = "royell";
          }
          // deployIdentity;
          "pdu1" = {
            hostname = "100.64.0.58";
            user = "royell";
          };
          "pdu2" = {
            hostname = "100.64.0.59";
            user = "royell";
          };
          "pdu3" = {
            hostname = "100.64.0.60";
            user = "royell";
          };
          "pdu4" = {
            hostname = "100.64.0.61";
            user = "royell";
          };
          "pdns.desk" = {
            hostname = "192.168.20.2";
            user = "ironman";
          }
          // deployIdentity;
          "printers.home" = {
            hostname = "192.168.254.10";
            user = "root";
          };
          "pve.desk" = {
            hostname = "192.168.20.253";
            user = "root";
          };
          "pve2.desk" = {
            hostname = "192.168.21.2";
            user = "root";
          };
          "pve-old.home" = {
            hostname = "192.168.248.3";
            user = "root";
          }
          // deployIdentity;
          "pve.home" = {
            hostname = "192.168.250.50";
            user = "root";
          }
          // deployIdentity;
          "pve2.home" = {
            hostname = "192.168.250.51";
            user = "root";
          }
          // deployIdentity;
          "pxe.desk" = {
            hostname = "192.168.20.3";
            user = "ironman";
          }
          // deployIdentity;
          "pxe.home" = {
            hostname = "192.168.254.8";
            user = "ironman";
          }
          // deployIdentity;
          "qc.desk" = {
            hostname = "192.168.20.7";
            user = "ironman";
          }
          // deployIdentity;
          "radius" = {
            hostname = "radius.royell.org";
            user = "root";
            extraOptions = {
              "KexAlgorithms" = "+diffie-hellman-group-exchange-sha1";
              "HostKeyAlgorithms" = "+ssh-rsa";
            };
          };
          "rcm.desk" = {
            hostname = "192.168.21.110";
            user = "root";
          }
          // deployIdentity;
          "rcm2" = {
            hostname = "rcm2.royell.org";
            user = "royell";
          }
          // deployIdentity;
          "rcm2.desk" = {
            hostname = "192.168.21.104";
            user = "ironman";
          }
          // deployIdentity;
          "rcm2.home" = {
            hostname = "192.168.248.119";
            user = "ironman";
          }
          // deployIdentity;
          "rcm3" = {
            hostname = "rcm3.royell.org";
            user = "royell";
            extraOptions."RemoteForward" = "/run/user/1000/gnupg/S.gpg-agent /run/user/1000/gnupg/S.gpg-agent.extra";
          };
          "royell-git" = {
            hostname = "git.royell.org";
          };
          "smx" = {
            hostname = "smx.royell.org";
            user = "royell";
          };
          "tasks2" = {
            hostname = "192.168.248.40";
            user = "ironman";
          }
          // deployIdentity;
          "traefik.desk" = {
            hostname = "192.168.20.3";
            user = "root";
          }
          // deployIdentity;
          "traefik.home" = {
            hostname = "192.168.252.102";
            port = 2222;
            user = "root";
          }
          // deployIdentity;
          "virtual1" = {
            hostname = "virtual.royell.org";
            user = "root";
          };
          "virtual2" = {
            hostname = "virtual2.royell.org";
            user = "root";
          };
          "virtual4" = {
            hostname = "virtual.royell.org";
            user = "root";
            port = 2224;
          };
          "virtual5" = {
            hostname = "virtual.royell.org";
            user = "root";
            port = 2225;
          };
          "virtual6" = {
            hostname = "virtual.royell.org";
            user = "root";
            port = 2226;
          };
          "virtual7" = {
            hostname = "virtual.royell.org";
            user = "root";
            port = 2227;
          };
          "voip" = {
            hostname = "voip.royell.org";
            port = 2020;
            user = "root";
          }
          // deployIdentity;
          "wolnut" = {
            hostname = "192.168.248.202";
            user = "ironman";
          }
          // deployIdentity;
          "zabbix" = {
            hostname = "zabbix.royell.org";
            user = "royell";
          };
        };
      };
      sops.secrets = {
        deploy_ed25519 = {
          inherit mode sopsFile;
          path = "${sshPath}/deploy_ed25519";
        };
        github = {
          inherit mode sopsFile;
          path = "${sshPath}/github";
        };
        royell_git = {
          inherit mode sopsFile;
          path = "${sshPath}/royell_git";
        };
      };
    };
}
