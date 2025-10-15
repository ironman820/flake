{ config, ... }:
{
  flake.homeConfigurations.niceastman =
    { pkgs, ... }:
    {
      imports = with config.flake.homeModules; [
        base
        neomutt
        work-email
      ];
      accounts.email.accounts.work.primary = true;
      home.packages = with pkgs; [
        qgis
        wireshark
        zoom-us
      ];
    };
}
