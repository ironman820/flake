{ options, pkgs, config, lib, inputs, ... }:

with lib;
# with lib.internal;
let
  cfg = config.ironman.work-laptop;
in {
  options.ironman.work-laptop = with types; {
    enable = mkBoolOpt false "Enable the Work Machine Tools";
  };

  config = mkIf cfg.enable {
    ironman.home = {
      file = {
        ".ssh/github_work.pub".source = ./keys/github_work.pub;
        ".ssh/id_ed25519_sk_work.pub".source = ./keys/id_ed25519_sk_work.pub;
      };
      extraOptions = {
        home = {
          packages = (with pkgs; [
            barrier
            birdtray
            # glocom
            qgis
            remmina
            teamviewer
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
  };
}
