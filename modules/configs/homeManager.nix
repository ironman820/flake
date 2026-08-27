{
  inputs,
  ...
}:
{
  flake.nixosModules.homeManager = {
      imports = [
        inputs.home-manager.nixosModules.home-manager
      ];
      home-manager = {
        backupFileExtension = "backup";
        useGlobalPkgs = false;
        useUserPackages = true;
      };
    };
}
