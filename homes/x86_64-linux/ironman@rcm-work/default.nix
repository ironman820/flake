{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (lib.mine) enabled;
in {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];
  mine.home = {
    suites = {
      server = {
        enable = true;
        rcm = enabled;
      };
    };
    user.name = config.snowfallorg.user.name;
  };
  home.shellAliases = {
    "sonars" = "sonar-scanner -Dsonar.projectKey=RCM -Dsonar.sources=. -Dsonar.host.url=https://qc.desk.niceastman.com -Dsonar.token=sqp_030096586777baff531e375a3e27ec0ce6fc779e";
  };
}
