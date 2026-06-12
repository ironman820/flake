{ inputs, self, ... }:
{
  flake.deploy.nodes = {
    calibre = {
      hostname = "calibre";
      profiles.system = {
        user = "root";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.calibre;
      };
      sshUser = "ironman";
    };
    files = {
      hostname = "files.home";
      profiles.system = {
        user = "root";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.zipline;
      };
      sshUser = "ironman";
    };
    llama = {
      hostname = "llama";
      profiles.system = {
        user = "root";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.llama;
      };
      remoteBuild = true;
      sshUser = "ironman";
    };
    llama-work = {
      hostname = "llama-work";
      profiles.system = {
        user = "root";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.llama-work;
      };
      remoteBuild = true;
      sshUser = "ironman";
    };
    lidarr = {
      hostname = "lidarr";
      profiles.system = {
        user = "root";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.lidarr;
      };
      sshUser = "ironman";
    };
    monday = {
      hostname = "monday";
      interactiveSudo = true;
      profiles.system = {
        user = "root";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.monday;
      };
      sshUser = "ironman";
    };
    netbox-work = {
      hostname = "netbox.desk";
      profiles.system = {
        user = "root";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.netbox-work;
      };
      sshUser = "ironman";
    };
    pass = {
      hostname = "pass";
      profiles.system = {
        user = "root";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.vaultwarden;
      };
      sshUser = "ironman";
    };
    pdns-home = {
      hostname = "pdns.home";
      profiles.system = {
        user = "root";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.pdns-home;
      };
      sshUser = "ironman";
    };
    pdns-work = {
      hostname = "pdns.desk";
      profiles.system = {
        user = "root";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.pdns-work;
      };
      sshUser = "ironman";
    };
    radarr = {
      hostname = "radarr";
      profiles.system = {
        user = "root";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.radarr;
      };
      sshUser = "ironman";
    };
    radius-work = {
      hostname = "radius.desk";
      profiles.system = {
        user = "root";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.radius-work;
      };
      sshUser = "ironman";
    };
    rcm-home = {
      hostname = "rcm.home";
      profiles.system = {
        user = "root";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.rcm-home;
      };
      sshUser = "ironman";
    };
    rcm-work = {
      hostname = "rcm.desk";
      profiles.system = {
        user = "root";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.rcm-work;
      };
      sshUser = "ironman";
    };
    rcm2-home = {
      hostname = "rcm2.home";
      profiles.system = {
        user = "root";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.rcm2-home;
      };
      sshUser = "ironman";
    };
    rcm2-work = {
      hostname = "rcm2.desk";
      profiles.system = {
        user = "root";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.rcm2-work;
      };
      sshUser = "ironman";
    };
    traefik = {
      hostname = "traefik.home";
      profiles.system = {
        user = "root";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.traefik;
      };
      sshUser = "ironman";
    };
    traefik-work = {
      hostname = "traefik.desk";
      profiles.system = {
        user = "root";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.traefik-work;
      };
      sshUser = "ironman";
    };
  };
}
