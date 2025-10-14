{config, inputs, ...}:
{
  flake.homeModules.base = {
    imports = with config.flake.homeModules; [
      inputs.sops-nix.homeModules.sops
    ];
    home.stateVersion = "25.05";
  };
}
