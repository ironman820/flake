{ inputs, ... }: {
  flake.homeModules.nixvim =
    { pkgs, ... }:
    {
      imports = [
        ../_nixvim.nix
      ];
      programs.nixvim = {
        enable = true;
        defaultEditor = true;
        nixpkgs.useGlobalPackages = true;
        plugins.lsp.servers.psalm.package =
          inputs.nixpkgs-php.legacyPackages.${pkgs.stdenv.hostPlatform.system}.php74Packages.psalm;
      };
    };
}
