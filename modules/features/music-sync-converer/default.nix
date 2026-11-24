{ inputs, moduleWithSystem, ... }: {
  flake.nixosModules.MusicSyncConverter = moduleWithSystem (
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
      inherit (lib.generators) toJSON;
      inherit (lib.types) int path str;
      cfg = config.programs.MusicSyncConverter;
    in
    {
      options.programs.MusicSyncConverter = {
        enable = mkEnableOption "Install MusicSyncConverter";
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
          makeMp3 = mkEnableOption "Create mp3 files instead of opus files";
          mp3Bitrate = mkOption {
            default = 192;
            description = "The bitrate of mp3 files created";
            type = int;
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
        environment.systemPackages = [
          self'.packages.MusicSyncConverter
        ];
        systemd = {
          services.music-sync-converter = mkIf cfg.service.enable {
            script =
              let
                syncConfig = pkgs.writeText "musicsync.json" ''
                  {
                  "SourceDir": "${cfg.service.sourceFolder}",
                  "TargetDir": "${cfg.service.destinationFolder}",
                  ${
                    if cfg.service.makeMp3 then
                      ''
                        "DeviceConfig": {
                          "FallbackFormat": {
                            "Extension": ".mp3",
                            "Codec": "mp3",
                            "Muxer": "mp3",
                            "Bitrate": ${toString cfg.service.mp3Bitrate},
                          },
                          "AlbumArt": {
                            "Codec": "mjpeg",
                            "Width": 320,
                            "Height": 320,
                          }
                        }
                      ''
                    else
                      ""
                  }
                '';
              in
              ''
                set -eu
                ${getExe self'.packages.MusicSyncConverter} ${syncConfig}
              '';
            serviceConfig = {
              Type = "oneshot";
              User = cfg.service.user;
            };
          };
          timers.music-sync-converter = mkIf cfg.service.enable {
            wantedBy = [ "timers.target" ];
            timerConfig = {
              OnBootSec = cfg.service.runInterval;
              OnUnitActiveSec = cfg.service.runInterval;
              Unit = "music-sync-converter.service";
            };
          };
        };
      };
    }
  );
  perSystem = { self', pkgs, ... }: {
    apps.MusicSyncConverter = {
      meta.description = "rsync for your music library. Sync your music library to MP3 players, phones, flash drives etc. while automatically converting unsupported files.";
      program = self'.packages.MusicSyncConverter;
    };
    packages.MusicSyncConverter = pkgs.buildDotnetModule {
      pname = "MusicSyncConverter";
      version = "0.1";

      src = inputs.music-sync-converter;

      projectFile = "src/MusicSyncConverter/MusicSyncConverter.sln";
      nugetDeps = ./deps.json;

      dotnet-sdk = pkgs.dotnetCorePackages.sdk_10_0_1xx;
      dotnet-runttime = pkgs.dotnetCorePackages.dotnet_10.runtime;
      executables = [ "MusicSyncConverter" ];
      meta = {
        description = "rsync for your music library. Sync your music library to MP3 players, phones, flash drives etc. while automatically converting unsupported files.";
        mainProgram = "MusicSyncConverter";
      };
      runtimeDeps = with pkgs; [
        android-tools
        ffmpeg
        flac
      ];
    };
  };
}
