{
  cell,
  inputs,
  pkgs,
}: {
  environment.systemPackages = with pkgs; [
    dmenu
    feh
  ];
  services.xserver.windowManager.dwm = {
    enable = true;
    package = pkgs.dwm.overrideAttrs (oa: {
      src = inputs.ironman-dwm;
    });
  };
}
