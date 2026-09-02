{ inputs, self, ... }:
let
  inherit (inputs.deploy-rs.lib.x86_64-linux) activate;
  nxc = self.nixosConfigurations;
in
{
  flake.deploy.nodes = {
    calibre = {
      hostname = "calibre";
      profiles.system = {
        user = "root";
        path = activate.nixos nxc.calibre;
      };
      sshUser = "ironman";
    };
    files = {
      hostname = "files.home";
      profiles.system = {
        user = "root";
        path = activate.nixos nxc.zipline;
      };
      sshUser = "ironman";
    };
    gns3-work = {
      hostname = "gns3-work";
      profiles.system = {
        user = "root";
        path = activate.nixos nxc.gns3-work;
      };
      remoteBuild = true;
      sshUser = "ironman";
    };
    llama = {
      hostname = "llama";
      profiles.system = {
        user = "root";
        path = activate.nixos nxc.llama;
      };
      remoteBuild = true;
      sshUser = "ironman";
    };
    llama-work = {
      hostname = "llama-work";
      profiles.system = {
        user = "root";
        path = activate.nixos nxc.llama-work;
      };
      remoteBuild = true;
      sshUser = "ironman";
    };
    lidarr = {
      hostname = "lidarr";
      profiles.system = {
        user = "root";
        path = activate.nixos nxc.lidarr;
      };
      sshUser = "ironman";
    };
    monday = {
      hostname = "monday";
      interactiveSudo = true;
      profiles.system = {
        user = "root";
        path = activate.nixos nxc.monday;
      };
      sshUser = "ironman";
    };
    netbox-work = {
      hostname = "netbox.desk";
      profiles.system = {
        user = "root";
        path = activate.nixos nxc.netbox-work;
      };
      sshUser = "ironman";
    };
    pass = {
      hostname = "pass";
      profiles.system = {
        user = "root";
        path = activate.nixos nxc.vaultwarden;
      };
      sshUser = "ironman";
    };
    pdns-work = {
      hostname = "pdns.desk";
      profiles.system = {
        user = "root";
        path = activate.nixos nxc.pdns-work;
      };
      sshUser = "ironman";
    };
    pve-work = {
      hostname = "pve.desk";
      profiles.system = {
        user = "root";
        path = activate.nixos nxc.pve-work;
      };
      sshUser = "ironman";
    };
    pve2 = {
      hostname = "pve2";
      profiles.system = {
        user = "root";
        path = activate.nixos nxc.pve2;
      };
      sshUser = "ironman";
    };
    radarr = {
      hostname = "radarr";
      profiles.system = {
        user = "root";
        path = activate.nixos nxc.radarr;
      };
      sshUser = "ironman";
    };
    radius-work = {
      hostname = "radius.desk";
      profiles.system = {
        user = "root";
        path = activate.nixos nxc.radius-work;
      };
      sshUser = "ironman";
    };
    rcm-home = {
      hostname = "rcm.home";
      profiles.system = {
        user = "root";
        path = activate.nixos nxc.rcm-home;
      };
      sshUser = "ironman";
    };
    rcm-work = {
      hostname = "rcm.desk";
      profiles.system = {
        user = "root";
        path = activate.nixos nxc.rcm-work;
      };
      sshUser = "ironman";
    };
    rcm2-home = {
      hostname = "rcm2.home";
      profiles.system = {
        user = "root";
        path = activate.nixos nxc.rcm2-home;
      };
      sshUser = "ironman";
    };
    rcm2-work = {
      hostname = "rcm2.desk";
      profiles.system = {
        user = "root";
        path = activate.nixos nxc.rcm2-work;
      };
      sshUser = "ironman";
    };
    sonarqube = {
      hostname = "sonarqube";
      profiles.system = {
        user = "root";
        path = activate.nixos nxc.sonarqube;
      };
      sshUser = "ironman";
    };
    storage = {
      hostname = "storage2.home";
      profiles.system = {
        user = "root";
        path = activate.nixos nxc.storage;
      };
      sshUser = "ironman";
    };
    traefik = {
      hostname = "traefik.home";
      profiles.system = {
        user = "root";
        path = activate.nixos nxc.traefik;
      };
      sshUser = "ironman";
    };
    traefik-work = {
      hostname = "traefik.desk";
      profiles.system = {
        user = "root";
        path = activate.nixos nxc.traefik-work;
      };
      sshUser = "ironman";
    };
  };
}
