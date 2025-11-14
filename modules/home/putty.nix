{
  flake.homeModules.putty =
    { flakeRoot, pkgs, ... }:
    {
      home = {
        file."putty/sessions/FS Switch".source = flakeRoot + "/.config/putty/${"FS%20Switch"}";
        packages = with pkgs; [
          putty
        ];
      };
    };
}
