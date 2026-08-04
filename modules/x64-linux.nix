{
  flake.nixosModules.x64-linux =
    _:
    {
      nixpkgs.hostPlatform = "x86_64-linux";
    };
}
