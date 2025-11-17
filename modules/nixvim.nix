{
  flake.nixosModules.nixvim = {
    imports = [
      ./_nixvim.nix
    ];
    programs.nixvim = {
      enable = true;
      defaultEditor = true;
    };
  };
}
