{
  self,
  ...
}:
{
  flake.nixosModules.userRoot = { lib, ... }: {
    home-manager.users = {
      root = self.homeConfigurations.core;
    };
    users.users.root = {
      initialHashedPassword = lib.mkForce null;
      initialPassword = "@ppl3Sauc3";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL3Ue/VoEgGG4nzoW3jpiwlnmWApkUyu/j1VmEwiSdy7"
      ];
    };
  };
}
