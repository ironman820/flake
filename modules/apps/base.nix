{
  flake.nixosModules.apps-base = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      cifs-utils
      enum4linux
    ];
  };
}
