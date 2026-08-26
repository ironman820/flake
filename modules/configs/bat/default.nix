{
  flake = {
    homeModules.bat = { lib, pkgs, ... }: {
      home = {
        shellAliases = {
          cat = "bat";
          diff = "batdiff";
          man = "batman";
          rg = "batgrep";
          watch = "batwatch --command";
        };
      };
      programs = {
        bash.bashrcExtra = ''
          eval $(${lib.getExe pkgs.bat-extras.batpipe})
        '';
        bat = {
          enable = true;
          config.theme = "tokyonight_night";
          extraPackages = with pkgs.bat-extras; [
            batdiff
            batgrep
            batman
            batpipe
            batwatch
            prettybat
          ];
          themes.tokyonight_night.src = ./tokyonight_night.tmTheme;
        };
      };
    };
  };
}
