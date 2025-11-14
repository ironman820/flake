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
  };
}
