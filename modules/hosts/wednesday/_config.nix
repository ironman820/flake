{
  hardware.facter.reportPath = ./facter.json;
  ironman = {
    extraGui = true;
    flatpaks = [
      "com.anydesk.Anydesk"
    ];
    niri =
      let
        niri_cmd = "niri msg output";
        niri_screen = "DP-4";
      in
      {
        lockOnClose = false;
        outputs = {
          "eDP-1" = {
            mode = {
              height = 1920;
              refresh = 60.001;
              width = 2880;
            };
            scale = 1.5;
          };
          "DP-4".enable = false;
        };
        screen = ''
          ${niri_cmd} ${niri_screen} on
          ${niri_cmd} ${niri_screen} mode "3840x2160@60.000000"
          ${niri_cmd} ${niri_screen} scale 1
          ${niri_cmd} eDP-1 off
        '';
        screen_reset.extraConfig = ''
          ${niri_cmd} ${niri_screen} off
        '';
      };
    user = {
      name = "niceastman";
      email = {
        bob = "nic.eastman";
        site = "royell.org";
      };
    };
  };
}
