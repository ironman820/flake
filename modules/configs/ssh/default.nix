{
  moduleWithSystem,
  self,
  ...
}:
{
  flake = {
    nixosModules.ssh = moduleWithSystem (
      perSystem@{ self', ... }:
      _: {
        environment.systemPackages = [
          self'.packages.switchssh
        ];
        services.openssh = {
          enable = true;
          settings.PermitRootLogin = "no";
        };
      }
    );
    homeModules.ssh = moduleWithSystem (
      perSystem@{ inputs', self', ... }:
      {
        config,
        ...
      }:
      let
        configFiles = ./files;
        sopsFile = "${self.outPath}/.secrets/ssh-keys.yaml";
        mode = "0400";
        sshPath = "${config.home.homeDirectory}/.ssh";
        deployIdentity = {
          identitiesOnly = true;
          identityFile = config.sops.secrets.deploy_ed25519.path;
        };
        switchSSH = {
          user = "royell";
          KexAlgorithms = [ "+diffie-hellman-group1-sha1" ];
          Ciphers = "+3des-cbc";
          HostKeyAlgorithms = "+ssh-dss,ssh-rsa";
        };
      in
      {
        home = {
          file = {
            ".ssh/deploy_ed25519.pub".source = "${toString configFiles}/deploy_ed25519.pub";
            ".ssh/github_home.pub".source = "${toString configFiles}/github_home.pub";
            ".ssh/github_servers.pub".source = "${toString configFiles}/github_servers.pub";
            ".ssh/github_work.pub".source = "${toString configFiles}/github_work.pub";
            ".ssh/gitlab.pub".source = "${toString configFiles}/gitlab.pub";
            ".ssh/id_rsa_yubikey.pub".source = "${toString configFiles}/id_rsa_yubikey.pub";
            ".ssh/royell_git_servers.pub".source = "${toString configFiles}/royell_git_servers.pub";
            ".ssh/royell_git_work.pub".source = "${toString configFiles}/royell_git_work.pub";
          };

          packages = [
            self'.packages.mytty
          ];
          shellAliases = {
            "ssh" = "TERM=xterm-256color ssh";
          };
        };
        programs.ssh = {
          enable = true;
          package = inputs'.nixpkgs-openssh.legacyPackages.openssh;
          enableDefaultConfig = false;
          settings = {
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
            "calibre" = {
              hostname = "192.168.248.101";
              user = "ironman";
            }
            // deployIdentity;
            "cr1" = {
              hostname = "162.216.110.106";
              user = "royell";
            };
            "cs1.fb.aub" = {
              hostname = "10.25.0.2";
              user = "royell";
            }
            // switchSSH;
            "cs1.crvl" = {
              hostname = "100.64.0.34";
              user = "royell";
            };
            "cs1.brkm.crvl" = {
              hostname = "10.10.8.2";
            }
            // switchSSH;
            "dns1" = {
              hostname = "dns1.royell.org";
              user = "root";
            };
            "dns2" = {
              hostname = "dns2.royell.org";
              user = "root";
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
            "ntp" = {
              hostname = "ntp.royell.org";
              user = "royell";
            }
            // deployIdentity;
            "pay" = {
              hostname = "pay.royell.net";
              user = "royell";
            }
            // deployIdentity;
            "pdns" = {
              hostname = "192.168.248.2";
              user = "ironman";
            }
            // deployIdentity;
            "pdns.desk" = {
              hostname = "192.168.20.2";
              user = "ironman";
            }
            // deployIdentity;
            "preseem" = {
              hostname = "208.80.144.36";
              user = "root";
            }
            // deployIdentity;
            "sonarqube" = {
              hostname = "192.168.248.107";
              user = "ironman";
            }
            // deployIdentity;
            "alerts" = {
              hostname = "alerts.royell.org";
              user = "royell";
            }
            // deployIdentity;
            "backup" = {
              hostname = "208.80.144.49";
              user = "root";
            };
            "default-calix-shelf" = {
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
            "cs1.mm.cstr" = {
              hostname = "10.10.36.2";
            }
            // switchSSH;
            "cs1.igr.nbrln" = {
              hostname = "10.10.51.2";
            }
            // switchSSH;
            "cs1.mm.irvg" = {
              hostname = "10.10.177.3";
              user = "royell";
            }
            // switchSSH;
            "cs1.mm.ltfld" = {
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
            "cs1.190.wvry" = {
              HostKeyAlgorithms = "+ssh-dss";
              hostname = "100.64.0.6";
            }
            // switchSSH;
            "cs1.mf.gir" = {
              hostname = "10.10.240.3";
              user = "royell";
            };
            "cs1.wt.vrdn" = {
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
              HostKeyAlgorithms = "+ssh-rsa";
              port = 8222;
              user = "root";
            };
            "docker" = {
              hostname = "docker.royell.org";
              user = "royell";
            };
            "docker2" = {
              hostname = "208.80.144.53";
              user = "royell";
            };
            "files.home" = {
              hostname = "192.168.248.103";
              user = "ironman";
            }
            // deployIdentity;
            "ftp" = {
              hostname = "208.80.144.71";
              user = "royell";
            }
            // deployIdentity;
            "git.royell.org" = {
              user = "git";
              hostname = "git.royell.org";
              identitiesOnly = true;
              identityFile = config.sops.secrets.royell_git.path;
            };
            "github.com" = {
              identitiesOnly = true;
              identityFile = config.sops.secrets.github.path;
            };
            "gitlab.com" = {
              identitiesOnly = true;
              identityFile = config.sops.secrets.gitlab.path;
            };
            "gns3-work" = {
              hostname = "192.168.21.199";
              user = "ironman";
            }
            // deployIdentity;
            "google" = {
              hostname = "google.royell.co";
              user = "royell";
            }
            // deployIdentity;
            "home-netbox" = {
              hostname = "192.168.253.3";
              user = "ironman";
            };
            # "llama-work" = {
            #   hostname = "192.168.21.199";
            #   user = "ironman";
            # }
            # // deployIdentity;
            "lidarr" = {
              hostname = "192.168.248.113";
              user = "ironman";
            }
            // deployIdentity;
            "mail" = {
              hostname = "webmail.royell.org";
              user = "royell";
            }
            // deployIdentity;
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
            "netbox.desk" = {
              hostname = "192.168.20.108";
              user = "ironman";
            }
            // deployIdentity;
            "netmon" = {
              hostname = "netmon.royell.org";
              user = "fastnetmon";
            }
            // deployIdentity;
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
            "pass" = {
              hostname = "192.168.248.108";
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
            "peanut" = {
              hostname = "192.168.248.200";
              user = "root";
            }
            // deployIdentity;
            "pve" = {
              hostname = "192.168.248.11";
              user = "root";
            }
            // deployIdentity;
            "pve.desk" = {
              hostname = "192.168.20.10";
              user = "ironman";
            }
            // deployIdentity;
            "pve2" = {
              hostname = "192.168.248.12";
              user = "ironman";
            }
            // deployIdentity;
            "radarr" = {
              hostname = "192.168.248.123";
              user = "ironman";
            }
            // deployIdentity;
            "radius" = {
              hostname = "radius.royell.org";
              user = "root";
              KexAlgorithms = [ "+diffie-hellman-group-exchange-sha1" ];
              HostKeyAlgorithms = "+ssh-rsa";
            };
            "rcm.desk" = {
              hostname = "192.168.20.102";
              user = "ironman";
            }
            // deployIdentity;
            "rcm.home" = {
              hostname = "192.168.248.121";
              user = "ironman";
            }
            // deployIdentity;
            "rcm2" = {
              hostname = "rcm2.royell.org";
              user = "royell";
            }
            // deployIdentity;
            "rcm2.desk" = {
              hostname = "192.168.20.107";
              user = "ironman";
            }
            // deployIdentity;
            "rcm2.home" = {
              hostname = "192.168.248.118";
              user = "ironman";
            }
            // deployIdentity;
            "rcm3" = {
              hostname = "rcm3.royell.org";
              user = "royell";
            };
            "share" = {
              hostname = "share.royell.org";
              user = "royell";
            }
            // deployIdentity;
            "smx" = {
              hostname = "smx.royell.org";
              user = "royell";
            };
            "storage.home" = {
              hostname = "192.168.248.100";
              user = "ironman";
            }
            // deployIdentity;
            "traefik.desk" = {
              hostname = "192.168.20.11";
              user = "ironman";
            }
            // deployIdentity;
            "traefik.home" = {
              hostname = "192.168.248.10";
              port = 2222;
              user = "ironman";
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
          };
          github = {
            inherit mode sopsFile;
          };
          gitlab = {
            inherit mode sopsFile;
          };
          royell_git = {
            inherit mode sopsFile;
          };
        };
      }
    );
  };
}
