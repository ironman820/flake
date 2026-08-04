{
  flake.nixosModules.kitty =
    { pkgs, self', ... }:
    {
      environment.systemPackages = with pkgs; [
        self'.packages.catppuccin-kitty
        kitty
      ];
    };
}
