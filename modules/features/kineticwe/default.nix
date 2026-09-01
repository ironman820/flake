{
  inputs,
  self,
  ...
}:
{
  flake = {
    nixosModules.kineticwe = { pkgs, ... }: {
      imports = with self.nixosModules; [
        inputs.kineticwe.nixosModules.default
        noctalia
        plasma
        sddm
      ];
      ironman.kineticwe = true;
      programs.kineticwe.enable = true;
    };
    homeModules.kineticwe =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      {
        imports = with self.homeModules; [
          inputs.kineticwe.homeModules.default
          noctalia
          plasma
        ];
        home.activation = {
          ironmanClearShortcuts = lib.hm.dag.entryBefore [ "configure-plasma" ] ''
            rm -f ${config.home.homeDirectory}/.config/kglobalshortcutsrc
          '';
          ironmanShortcuts =
            let
              kglobalshortcutsrc = pkgs.writeText "kglobalshortcutsrc" (builtins.readFile ./kglobalshortcutsrc);
            in
            lib.hm.dag.entryAfter [ "writeBoundary" ] ''
              ln -sf ${kglobalshortcutsrc} ${config.home.homeDirectory}/.config/kglobalshortcutsrc
            '';
        };
        programs = {
          kineticwe.enable = true;
          plasma = {
            enable = true;
            configFile = {
              kwinrc = {
                Desktops = {
                  Name_1 = 1;
                  Name_2 = 2;
                  Name_3 = 3;
                  Name_4 = 4;
                  Name_5 = 5;
                  Name_6 = 6;
                  Name_7 = 7;
                  Name_8 = 8;
                  Name_9 = 9;
                  Number = lib.mkForce 9;
                  Rows = 9;
                };
                Effect-overview.BorderActivate = 9;
                MouseBindings.CommandAllWheel = "Previous/Next Desktop";
                Tiling = {
                  EnabledLayouts = "MasterStack,CenterTile,Columns,AutoGrid";
                  GapBetween = 20;
                  GapBottom = 10;
                  GapLeft = 15;
                  GapRight = 15;
                  GapTop = 10;
                  TilingBorderMode = "ActiveOnly";
                  TilingBorderThickness = 5;
                  TilingCornerRadius = 10;
                };
                Windows.InvertScrollDesktopSwitch = true;
                Xwayland.Scale = 1;
              };
              kwinrulesrc = {
                General = {
                  count = 1;
                  rules = "a0317d8e-1f89-4e30-960a-f368ed64c262";
                };
                a0317d8e-1f89-4e30-960a-f368ed64c262 = {
                  Description = "Opacity";
                  opacityactive = 98;
                  opacityactiverule = 2;
                  opacityinactive = 95;
                  opacityinactiverule = 2;
                  types = 66461;
                };
              };
            };
          };
        };
      };
  };
}
