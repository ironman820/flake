{ pkgs, config, lib, ... }:
{
  imports = [
    ./hardware.nix
  ];

  config = {
    home-manager.users.${config.ironman.user.name} = {
      home = {
        file = {
          ".config/is_personal".text = ''true'';
        };
        packages = with pkgs; [
          calibre
        ];
      };
      programs.git.signing = {
        key = "~/.ssh/github_home";
        signByDefault = builtins.stringLength "~/.ssh/github_home" > 0;
      };
    };
    ironman = {
      stylix = {
        enable = true;
        image = ../../files/girl-mech.png;
      };
    #   home.extraOptions = {
    #   };
    };
    networking.hostName = "ironman-laptop";
    zramSwap = {
      enable = true;
      memoryPercent = 90;
    };
  };
}
