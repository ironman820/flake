{
  flake.nixosModules.sound =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        pavucontrol
        pipewire
      ];
      security.rtkit.enable = true;
      services = {
        pipewire = {
          alsa = {
            enable = true;
            support32Bit = true;
          };
          enable = true;
          pulse.enable = true;
        };
        pulseaudio.enable = false;
      };
    };
}
