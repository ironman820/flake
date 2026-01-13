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
          inherit (st) folders;
          devices = st.devices // {
            nas.id = "MAJ6SK3-COCJQMB-BUCAUK5-KNIQPBP-2HCZLDM-Y52DUGR-CUQLSUV-ST3B7AQ";
            work-desktop = {
              id = "7IZVF2E-CZPRZV3-QRVU5M5-ZFN4QBN-GB2PX3Z-4GBGNXB-ZJSH5DB-63CEZA6";
              name = "Work Desktop";
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
