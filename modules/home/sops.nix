{
  flake.homeModules.sops =
    {
      config,
      ...
    }:
    {
      sops = {
        age = {
          generateKey = false;
          keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
          sshKeyPaths = [ ];
        };
        gnupg.sshKeyPaths = [ ];
      };
    };
}
