{ inputs, self, ... }: {
  flake.nixosModules.niri = { pkgs, ... }: {
    imports = with self.nixosModules; [
      noctalia
      sddm
    ];
    environment.systemPackages = with pkgs; [
      xwayland-satellite
    ];
    programs.niri.enable = true;
    services.logind.settings.Login = {
      HandleLidSwitch = "ignore";
      HandleLidSwitchExternalPower = "ignore";
    };
  };
  perSystem = { lib, pkgs, ... }: {
    packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      settings = {
        input.keyboard.xkb.layout = "us";
        layout.gaps = 5;
        binds = {
          "Mod+H".focus-column-left = _:{};
          "Mod+L".focus-column-right = _:{};
          "Mod+Q".close-window = _:{};
          "Mod+Return".spawn-sh = lib.getExe pkgs.kitty;
          "Mod+Shift+Q".quit = _:{};
          "Mod+Shift+slash".show-hotkey-overlay = _:{};
        };
      };
    };
  };
}
