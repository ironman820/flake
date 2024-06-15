{
  cell,
  inputs,
  pkgs,
}: {
  environment.systemPackages = [
    pkgs.dmenu
  ];
  services.xserver.windowManager.dwm = {
    enable = true;
    package = pkgs.dwm.overrideAttrs (oa: {
      src = inputs.ironman-dwm;
    });
  };
}
