{
  hardware.facter.reportPath = ./facter.json;
  ironman = {
    extraGui = true;
    niri.outputs = {
      "eDP-1" = {
        mode = {
          height = 1200;
          refresh = 60.;
          width = 1920;
        };
        scale = 1;
      };
    };
  };
}
