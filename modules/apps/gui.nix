{
  flake.nixosModules.apps-gui =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        mmex
      ];
    };
}
