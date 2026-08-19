{ self, ... }: {
  flake.nixosModules.kitty =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        self.packages.${pkgs.stdenv.hostPlatform.system}.catppuccin-kitty
        kitty
      ];
    };
}
