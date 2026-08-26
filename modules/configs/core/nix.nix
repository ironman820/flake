{
  flake = {
    nixosModules.nix =
      {
        lib,
        pkgs,
        ...
      }:
      let
        inherit (lib) mkDefault;
      in
      {
        nix = {
          channel.enable = false;
          settings = {
            cores = mkDefault 1;
            experimental-features = [
              "nix-command"
              "flakes"
            ];
            trusted-users = [
              "root"
              "@wheel"
            ];
          };
        };
        nixpkgs = {
          config = {
            allowUnfree = true;
            permittedInsecurePackages = [
              "googleearth-pro-7.3.7.1155"
              "ilmbase-2.5.10"
              "openssl-1.1.1w"
            ];
          };
        };
        programs.nix-ld.enable = true;
      };
    homeModules.nix = { config, pkgs,  ... }: {
      home = {
        packages = with pkgs; [
          nil
          nixd
        ];
        sessionVariables.NH_FLAKE = "${config.home.homeDirectory}/git/flake";
      };
      nixpkgs.config.allowUnfree = true;
      programs = {
        nh = {
          enable = true;
          clean = {
            enable = true;
            dates = "weekly";
            extraArgs = "-k 5";
          };
          flake = "${config.home.homeDirectory}/git/flake";
        };
        nix-index = {
          enable = true;
          enableBashIntegration = true;
        };
      };
    };
  };
}
