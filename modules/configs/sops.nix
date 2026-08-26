{
  inputs,
  self,
  ...
}:
{
  flake = {
    nixosModules.sops = {
      imports = (
        with inputs;
        [
          sops-nix.nixosModules.sops
        ]
      );
      sops = {
        age = {
          generateKey = true;
          keyFile = "/etc/nixos/keys.txt";
          sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
        };
        gnupg.sshKeyPaths = [ ];
      };
    };
    homeModules.sops = { config, osConfig, ... }: {
      imports = (
        with inputs;
        [
          sops-nix.homeModules.sops
        ]
      );
      sops = {
        age = {
          generateKey = false;
          keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
          sshKeyPaths = [ ];
        };
        gnupg.sshKeyPaths = [ ];
        secrets.nix_conf = {
          sopsFile = "${self.outPath}/.secrets/nix.yaml";
          path = "/home/${osConfig.ironman.user.name}/.config/nix/nix.conf";
        };
      };
    };
  };
}
