{ channels, ... }:
final: prev:
{
  inherit (channels.nixpkgs-ba45a55) php74 php74Extensions;
  inherit (channels.nixpkgs-ba45a55.unixODBCDrivers) msodbcsql17;
  inherit (prev.ironman.php.packages) psalm;
}
