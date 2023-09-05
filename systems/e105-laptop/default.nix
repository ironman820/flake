{ pkgs, config, ... }:
{
  imports = [
    ./hardware.nix
  ];

  ironman = {
    sops.secrets.office_psk = {
      format = "binary";
      mode = "0400";
      path = "/etc/NetworkManager/system-connections/office.nmconnection";
      sopsFile = ../../secrets/office.wifi;
    };
    stylix = {
      enable = true;
      image = ../../files/voidbringer.png;
    };
  };
  home-manager.users.${config.ironman.user.name} = {
    home = {
      file = {
        ".config/is_personal".text = ''false'';
      };
      packages = (with pkgs; [
        barrier
        # glocom
        qgis
        teams
        thunderbird
        wireshark
      ]);
    };
    programs.git.signing = {
      key = "~/.ssh/github_work";
      signByDefault = builtins.stringLength "~/.ssh/github_work" > 0;
    };
  };
  networking.hostName = "e105-laptop";
}
