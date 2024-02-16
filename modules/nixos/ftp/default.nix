{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.mine) mkBoolOpt mkOpt;
  inherit (lib.types) listOf str;
  cfg = config.mine.servers.ftp;
in {
  options.mine.servers.ftp = {
    enable = mkEnableOption "Enable or disable tftp support";
    chrootlocalUser = mkBoolOpt true "Keep local users in their folders";
    userlist = mkOpt (listOf str) [config.mine.user.name] "List of users to allow";
    localRoot = mkOpt str "/var/www/$USER" "Root directory for file storage";
    writeEnable = mkBoolOpt true "Allow users to write";
  };

  config = mkIf cfg.enable {
    networking.firewall = mkIf config.mine.networking.firewall {
      allowedTCPPorts = [
        21
      ];
    };
    services.vsftpd = {
      inherit (cfg) chrootlocalUser enable localRoot userlist writeEnable;
      root = "/etc/ftp";
    };
  };
}
