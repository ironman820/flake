{
  inputs,
  self,
  system,
  ...
}: final: prev: {
  inherit (inputs.nixpkgs-ba45a55.legacyPackages.${system}) php74 php74Extensions php74Packages;
  inherit (inputs.nixpkgs-ba45a55.legacyPackages.${system}.unixODBCDrivers) msodbcsql17;
  inherit (self.packages.${system}.php.packages) psalm;
}
