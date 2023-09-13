{ options, pkgs, config, lib, inputs, ... }:

with lib;
# with lib.internal;
let
  cfg = config.ironman.work-tools;
in
{
  options.ironman.work-tools = with types; {
    enable = mkBoolOpt false "Enable the Work Machine Tools";
  };

  config = mkIf cfg.enable {
    ironman.home = {
      extraOptions = {
        home = {
          packages = (with pkgs; [
            barrier
            # glocom
            qgis
            teams
            thunderbird
            wireshark
            zoom-us
          ]);
        };
        programs = {
          git = {
            signing = {
              key = "~/.ssh/github_work";
              signByDefault = builtins.stringLength "~/.ssh/github_work" > 0;
            };
            userName = config.ironman.user.fullName;
            userEmail = config.ironman.user.email;
          };
        };
      };
    };
    networking.firewall.allowedTCPPorts = [
      24800
    ];
  };
}
