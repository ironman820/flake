{
  flake.nixosModules.arduino =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        arduino-ide
        arduino-create-agent
      ];
    };
}
