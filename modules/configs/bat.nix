{
  flake.homeModules.bat = { lib, pkgs, ... }: {
    home = {
      sessionVariables.PAGER = "bat";
      shellAliases = {
        cat = "bat";
        diff = "batdiff";
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
        extraPackages = with pkgs.bat-extras; [
          batdiff
          batgrep
          batman
          batpipe
          batwatch
          prettybat
        ];
      };
    };
  };
}
