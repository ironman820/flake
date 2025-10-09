{
  inputs,
  pkgs,
  ...
}: let
  inherit (inputs.nixpkgs-ba45a55.legacyPackages.${pkgs.system}.php74) buildEnv;
  # inherit (inputs.nixpkgs-ba45a55.legacyPackages.${pkgs.system}.php74Packages)
  # php-cs-fixer phpcbf;
in
  buildEnv {
    extensions = {
      all,
      enabled,
    }:
      enabled ++ (with all; [sqlsrv]);
  }
