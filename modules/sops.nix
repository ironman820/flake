{
  flake.nixosModules.sops = {
    sops.age = {
      generateKey = false;
      keyFile = "/etc/nixos/keys.txt";
      sshKeyPaths = [];
    };
  };
}
