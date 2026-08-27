{
  flake.homeModules.putty =
    { pkgs, ... }:
    {
      home = {
        file.".putty/sessions/FS%20Switch".source = "./FS%20Switch";
        packages = [
          pkgs.putty
        ];
      };
    };
}
