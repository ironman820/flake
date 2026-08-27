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
          overrideFolders = true;
          settings = {
            inherit (st) folders;
            devices = st.devices // {
              nas.id = "MAJ6SK3-COCJQMB-BUCAUK5-KNIQPBP-2HCZLDM-Y52DUGR-CUQLSUV-ST3B7AQ";
              phone.id = "YEXTAE5-7ZTCY7M-ZXBBE7Z-LO3GXUV-XIHCFDJ-SBDPV22-VJEOUDJ-QO7GGQG";
              work-desktop = {
                id = "7IZVF2E-CZPRZV3-QRVU5M5-ZFN4QBN-GB2PX3Z-4GBGNXB-ZJSH5DB-63CEZA6";
                name = "Work Desktop";
              };
            };
            gui.theme = "black";
            options = {
              listenAddresses = [ "tcp" ];
              minHomeDiskFree = {
                unit = "%";
                value = 1;
              };
              urAccepted = -1;
            };
          };
        };
      };
  };
}
