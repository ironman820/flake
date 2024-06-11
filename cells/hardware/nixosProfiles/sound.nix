{
  cell,
  inputs,
  pkgs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  l = nixpkgs.lib // mine.lib // builtins;
in {
  environment.systemPackages = with pkgs; [
    pavucontrol
    pipewire
  ];
  hardware.pulseaudio = l.disabled;
  security.rtkit = l.enabled;
  services.pipewire = {
    alsa = {
      enable = true;
      support32Bit = true;
    };
    enable = true;
    pulse = l.enabled;
  };
  sound = l.disabled;
}
