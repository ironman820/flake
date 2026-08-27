{
  flake.nixosModules.sound =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        pavucontrol
      ];
      security.rtkit.enable = true;
      services = {
        pipewire = {
          enable = true;
          alsa = {
            enable = true;
            support32Bit = true;
          };
          pulse.enable = true;
        };
      };
    };
}
