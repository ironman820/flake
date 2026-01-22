{ inputs, self, ... }:
{
  flake.deploy.nodes = {
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
      remoteBuild = true;
      sshUser = "ironman";
    };
    monday = {
      hostname = "monday";
      interactiveSudo = true;
      profiles.system = {
        user = "root";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.monday;
      };
      remoteBuild = false;
      sshUser = "ironman";
    };
    rcm-work = {
      hostname = "rcm.desk";
      profiles.system = {
        user = "root";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.rcm-work;
      };
      remoteBuild = false;
      sshUser = "ironman";
    };
    rcm-home = {
      hostname = "rcm.home";
      profiles.system = {
        user = "root";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.rcm-home;
      };
      remoteBuild = false;
      sshUser = "ironman";
    };
    rcm2-home = {
      hostname = "rcm2-new.home";
      profiles.system = {
        user = "root";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.rcm2-home;
      };
      remoteBuild = false;
      sshUser = "root";
    };
    traefik = {
      hostname = "traefik.home";
      profiles.system = {
        user = "root";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.traefik;
      };
      remoteBuild = true;
      sshUser = "ironman";
    };
  };
}
