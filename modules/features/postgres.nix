{
  flake.nixosModules.postgres =
    {
      config,
      lib,
      ...
    }:
    let
      inherit (lib)
        mkEnableOption
        mkForce
        mkIf
        mkOption
        ;
      inherit (lib.types)
        str
        nullOr
        path
        ;
      pgs = config.ironman.postgres;
      userName = config.ironman.user.name;
    in
    {
      options.ironman.postgres = {
        enable = mkEnableOption "Enable postgres server";
        dbName = mkOption {
          default = "ironman";
          description = "Name for the postgres database and user.";
          type = str;
        };
        external = {
          enable = mkEnableOption "Enable external access to the database";
          ip = mkOption {
            default = "172.16.0.0/12";
            description = "IP range to accept connections from.";
            type = str;
          };
        };
        initialScript = mkOption {
          default = null;
          description = "Path to the file with a init script for the server";
          type = nullOr path;
        };
      };
      config = {
        services.postgresql = {
          inherit (pgs) enable;
          authentication =
            if (!pgs.external.enable) then
              (lib.mkForce ''
                local all all ident map=${pgs.dbName}
              '')
            else
              ''
                host ${pgs.dbName} ${pgs.dbName} ${pgs.external.ip} password
              '';
          enableTCPIP = pgs.external.enable;
          ensureDatabases = [
            pgs.dbName
          ];
          ensureUsers = [
            {
              ensureDBOwnership = true;
              name = pgs.dbName;
            }
          ];
          identMap = mkIf (!pgs.external.enable) ''
            ${pgs.dbName} ${userName} ${pgs.dbName}
            ${pgs.dbName} postgres postgres
          '';
          initialScript = mkIf (!isNull pgs.initialScript) pgs.initialScript;
          settings.listen_address = mkIf pgs.external.enable (mkForce "*");
        };
      };
    };
}
