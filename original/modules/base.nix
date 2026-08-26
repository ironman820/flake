{ inputs, self, ... }:
{
  flake.nixosModules.base =
    {
      lib,
      pkgs,
      ...
    }:
    {
      imports = (with inputs; [
        disko.nixosModules.disko
        niri.nixosModules.niri
        nix-topology.nixosModules.default
        nixvim.nixosModules.nixvim
        noctalia.nixosModules.default
        noctalia-greeter.nixosModules.default
        sops-nix.nixosModules.sops
      ]) ++ (with self.nixosModules; [
        git
        ironman
        nix
        nixvim
        tmux
      ]);
      networking.useDHCP = lib.mkDefault true;
      programs = {
        bat = {
          enable = true;
          extraPackages = with pkgs.bat-extras; [
            batdiff
            batgrep
            batman
            batpipe
            batwatch
            prettybat
          ];
        };
        # command-not-found.enable = false;
        direnv = {
          enable = true;
          nix-direnv.enable = true;
        };
        java = {
          binfmt = true;
          enable = true;
          package = pkgs.jdk;
        };
        mtr.enable = true;
      };
      security.sudo = {
        execWheelOnly = true;
      };
      services.openssh.enable = true;
      sops = {
        age = {
          generateKey = true;
          keyFile = "/etc/nixos/keys.txt";
          sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
        };
        gnupg.sshKeyPaths = [ ];
      };
      systemd.settings.Manager = {
        DefaultTimeoutStopSec = "10s";
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
