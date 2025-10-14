{
  flake.homeModules.sops =
    {
      config,
      ...
    }:
    {
      sops = {
        age = {
          keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
          sshKeyPaths = [ ];
        };
        gnupg.sshKeyPaths = [ ];
      };
    };
}
