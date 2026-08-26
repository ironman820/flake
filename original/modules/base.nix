{ inputs, self, ... }:
{
  flake.nixosModules.base =
    {
      lib,
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
      ]) ++ (with self.nixosModules; [
        git
        ironman
        nix
        nixvim
        tmux
      ]);
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
