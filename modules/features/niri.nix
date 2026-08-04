{ inputs, self, ... }: {
  perSystem = { lib, pkgs, ... }: {
    packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      settings = {
        input.keyboard.xkb.layout = "us";
        layout.gaps = 5;
        binds = {
          "Mod+H".focus-column-right = _:{};
          "Mod+L".focus-column-left = _:{};
          "Mod+Q".close-window = _:{};
          "Mod+Return".spawn-sh = lib.getExe pkgs.kitty;
          "Mod+Shift+Q".quit = _:{};
          "Mod+Shift+slash".show-hotkey-overlay = _:{};
        };
      };
    };
  };
}
