{ config, lib, ... }:
let inherit (lib.ironman) enabled;
in {
  ironman.home = {
    suites.server = {
      enable = true;
      rcm2 = enabled;
    };
    user.name = config.snowfallorg.user.name;
  };
  home.shellAliases = {
    "sonars" =
      "sonar-scanner -Dsonar.projectKey=RCM2 -Dsonar.sources=. -Dsonar.host.url=https://qc.desk.niceastman.com -Dsonar.token=sqp_4de32f09e2137f5459d22b658bf98cccfc98e533";
  };
}
