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
          sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
        };
        gnupg.sshKeyPaths = [ ];
      };
    };
}
