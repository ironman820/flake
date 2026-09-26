{
  flake = {
    nixosModules.syncthing =
      { lib, ... }:
      let
        inherit (lib) mkOption;
        inherit (lib.types) attrs nullOr path;
      in
      {
        options.ironman.syncthing = {
          cert = mkOption {
            default = null;
            type = nullOr path;
          };
          devices = mkOption {
            default = { };
            type = attrs;
          };
          folders = mkOption {
            default = { };
            type = attrs;
          };
          key = mkOption {
            default = null;
            type = nullOr path;
          };
        };
        config.services.syncthing.openDefaultPorts = true;
      };
    homeModules.syncthing =
      { lib, osConfig, ... }:
      let
        inherit (builtins) isPath;
        inherit (lib) mkIf;
        st = osConfig.ironman.syncthing;
      in
      {
        services.syncthing = {
          enable = true;
          cert = mkIf (isPath st.cert) st.cert;
          key = mkIf (isPath st.key) st.key;
          settings = {
            inherit (st) folders;
            devices = st.devices // {
              friday.id = "C2T72DJ-35SQ4DJ-OTQFZUH-R54J3FK-7K2M46K-RAN5SFU-4Y4ZNIL-FZ64AQQ";
              M500_MIKU.id = "NXYJYHC-TSITMOQ-KICX3MA-P3Q3NDQ-HVQIYZJ-4C2LRTJ-CCJA357-6357AQ2";
              nas.id = "MAJ6SK3-COCJQMB-BUCAUK5-KNIQPBP-2HCZLDM-Y52DUGR-CUQLSUV-ST3B7AQ";
              phone.id = "YEXTAE5-7ZTCY7M-ZXBBE7Z-LO3GXUV-XIHCFDJ-SBDPV22-VJEOUDJ-QO7GGQG";
              storage.id = "CNMVTVS-4PTOXZY-PO6E2SZ-R7UAVMV-4ZOE7KI-VCVGRA7-Z6LRDHJ-PUSCIAZ";
              wednesday.id = "ICGQ6GR-GFFLBJB-N4AF3AP-IOSLCHN-337F5UX-RW2A35G-UZ3Q2N4-SVWXTQY";
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
            relay.enable = true;
          };
        };
      };
  };
}
