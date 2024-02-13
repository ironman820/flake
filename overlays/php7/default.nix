{channels, ...}: final: prev: {
  inherit (prev.ironman) php;
  inherit (channels.nixpkgs-ba45a55) php74 php74Extensions php74Packages;
  inherit (channels.nixpkgs-ba45a55.unixODBCDrivers) msodbcsql17;
  inherit (final.php74Packages) psalm;
}
