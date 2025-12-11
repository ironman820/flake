{ inputs, self, ... }:
{
  flake.deploy.nodes = {
    icewarp = {
      hostname = "icewarp";
      profiles.system = {
        user = "root";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.icewarp;
      };
      remoteBuild = true;
      sshUser = "royell";
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
  };
}
