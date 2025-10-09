{
  flake.nixosModules.x64-linux =
    { ... }:
    {
      nixpkgs.hostPlatform = "x86_64-linux";
    };
}
