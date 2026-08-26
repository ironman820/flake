{
  inputs,
  moduleWithSystem,
  ...
}:
{
  flake.nixosModules.homeManager = moduleWithSystem (
    perSystem@{ ... }:
    _: {
      imports = [
        inputs.home-manager.nixosModules.home-manager
      ];
      home-manager = {
        backupFileExtension = "backup";
        useGlobalPkgs = false;
        useUserPackages = true;
      };
    }
  );
}
