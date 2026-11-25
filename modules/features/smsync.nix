{
  moduleWithSystem,
  ...
}:
{
  flake.nixosModules.smsync = moduleWithSystem (
    perSystem@{ self', ... }:
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib)
        getExe
        mkEnableOption
        mkOption
        mkIf
        ;
      inherit (lib.types) listOf path str;
      cfg = config.programs.smsync;
    in
    {
      options.programs.smsync = {
        enable = mkEnableOption "Install smsync";
        service = {
          enable = mkEnableOption "Setup Timed Sync Service";
          sourceFolder = mkOption {
            description = "Folder that should source files from";
            example = "/mnt/music";
            type = path;
          };
          destinationFolder = mkOption {
            description = "Destination folder where files should be saved";
            example = "/mnt/player";
            type = path;
          };
          excludePaths = mkOption {
            default = [ ];
            description = "List of sub-paths to exclude from the sync";
            type = listOf str;
          };
          runInterval = mkOption {
            default = "5m";
            description = "Systemd timer notation on runtime interval";
            type = str;
          };
          user = mkOption {
            default = config.ironman.user.name;
            description = "The user to run the service under";
            type = str;
          };
        };
      };
      config = mkIf cfg.enable {
        environment.systemPackages = with pkgs; [
          ffmpeg
          flac
          self'.packages.smsync
        ];
        systemd = {
          services.smsync = mkIf cfg.service.enable {
            script =
              let
                syncConfig = (pkgs.formats.yaml { }).generate "smsync.yaml" {
                  source_dir = cfg.service.sourceFolder;
                  exclude = cfg.service.excludePaths;
                  rules = [
                    {
                      source = "flac";
                      target = "mp3";
                      conversion = "vbr:5|cl:3";
                    }
                    {
                      source = "mp3";
                      conversion = "copy";
                    }
                  ];
                };
              in
              ''
                cd ${cfg.service.destinationFolder}
                mv .stfolder /tmp/
                mv .stignore /tmp/
                if [ ! -f smsync.yaml ]; then
                  cp ${syncConfig} smsync.yaml
                fi
                ${getExe self'.packages.smsync} -y
                mv /tmp/.stignore ./
                mv /tmp/.stfolder ./
              '';
            serviceConfig = {
              Type = "exec";
              User = cfg.service.user;
            };
          };
          timers.smsync = mkIf cfg.service.enable {
            wantedBy = [ "timers.target" ];
            timerConfig = {
              OnBootSec = cfg.service.runInterval;
              OnUnitActiveSec = cfg.service.runInterval;
              Unit = "smsync.service";
            };
          };
        };
      };
    }
  );
  perSystem =
    {
      # config,
      self',
      lib,
      pkgs,
      # system,
      ...
    }:
    {
      apps.smsync = {
        meta.description = "smsync keeps huge music collections in sync and is takes care of conversions between different formats.";
        program = self'.packages.smsync;
      };
      packages.smsync = pkgs.buildGoModule (finalAttrs: {
        pname = "smsync";
        version = "3.5.2";

        src = pkgs.fetchFromGitHub {
          owner = "mipimipi";
          repo = "smsync";
          tag = "v${finalAttrs.version}";
          hash = "sha256-UWjgZhh/3QlAXMJh+5FqLbhrQl4BkhZoRDYiyBP41j0=";
        };

        vendorHash = "sha256-1VAgZsLnVByIwukQTN1vNYJMA2MKqEVT2trrUsvqO+Y=";

        meta = {
          description = "smsync keeps huge music collections in sync and is takes care of conversions between different formats.";
          homepage = "https://github.com/mipimipi/smsync";
          license = lib.licenses.gpl3;
          mainProgram = "smsync";
        };
        runtimeDeps = with pkgs; [
          ffmpeg
          flac
        ];
      });
    };
}
