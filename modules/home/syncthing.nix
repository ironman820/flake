{
  flake.homeModules.syncthing =
    { lib, osConfig, ... }:
    let
      inherit (builtins) isPath;
      inherit (lib) mkIf;
      username = osConfig.ironman.user.name;
      st = osConfig.ironman.syncthing;
    in
    {
      services.syncthing = {
        enable = true;
        cert = mkIf (isPath st.cert) st.cert;
        key = mkIf (isPath st.key) st.key;
        overrideFolders = true;
        settings = {
          devices = st.devices // {
            nas.id = "MAJ6SK3-COCJQMB-BUCAUK5-KNIQPBP-2HCZLDM-Y52DUGR-CUQLSUV-ST3B7AQ";
            phone.id = "YEXTAE5-7ZTCY7M-ZXBBE7Z-LO3GXUV-XIHCFDJ-SBDPV22-VJEOUDJ-QO7GGQG";
          };
          folders = st.folders // {
            "/home/${username}/Wallpapers" = {
              id = "gtwyq-tfzfb";
              devices = [
                "nas"
              ];
              label = "Wallpapers";
              versioning = {
                type = "simple";
                params.keep = "10";
              };
            };
          };
          gui.theme = "black";
          options = {
            minHomeDiskFree = {
              unit = "%";
              value = 1;
            };
            urAccepted = -1;
          };
        };
      };
    };
}
