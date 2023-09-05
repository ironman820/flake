let
  ironman = {
    # boot = import ./boot;
    # config = import ./config;
    default = import ./default;
    # firmware = import ./firmware;
    # networking = import ./networking;
    # personal-apps = import ./personal-apps;
    # servers = import ./servers;
    sops = import ./sops;
    stylix = import ./stylix;
    # tmux = import ./tmux;
    user = import ./user;
    # virtual = import ./virtual;
  };
in
{
  inherit ironman;
}
