{
  self,
  ...
}:
{
  flake = {
    nixosModules.navidrome =
      { config, lib, ... }:
      let
        inherit (import ./_traefikModule.nix { inherit lib; }) mkTraefikOptions mkTraefikConfig;
        cfg = config.ironman.navidrome;
      in
      {
        options.ironman.navidrome = mkTraefikOptions {
          service = "Navidrome";
          domain = "mymusic";
          port = "4533";
          private = false;
        };
        #   {
        #   enable = mkEnableOption "Install navidrome server";
        #   ip = mkOption {
        #     default = null;
        #     description = "Navidrome's IP address";
        #     type = types.nullOr types.str;
        #   };
        # };
        config = {
          services = {
            navidrome = {
              inherit (cfg) enable;
              environmentFile = config.sops.secrets.navidrome_env.path;
              group = config.ironman.user.name;
              settings = {
                Address = "0.0.0.0";
                DataFolder = "/shares/data/docker/navidrome";
                DefaultUIVolume = "75";
                EnableInsightsCollector = false;
                EnforceNonRootUser = true;
                MusicFolder = "/shares/data/music";
              };
              user = config.ironman.user.name;
            };
            traefik.dynamicConfigOptions.http = mkTraefikConfig {
              inherit cfg;
              name = "navidrome";
            };
          };
          sops.secrets.navidrome_env = {
            sopsFile = "${self.outPath}/.secrets/navidrome.yaml";
            owner = cfg.user.name;
            group = cfg.user.name;
          };
        };
      };
  };
}
