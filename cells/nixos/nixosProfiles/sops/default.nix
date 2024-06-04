{
  sops = {
    age = {
      keyFile = "/etc/nixos/keys.txt";
      sshKeyPaths = [];
    };
    defaultSopsFile = ./__secrets/sops.yaml;
    gnupg.sshKeyPaths = [];
    secrets.user_pass.neededForUsers = true;
  };
}
