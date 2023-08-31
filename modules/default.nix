let
  ironman = {
    # boot = import ./boot;
    # config = import ./config;
    # firmware = import ./firmware;
    # networking = import ./networking;
    # personal-apps = import ./personal-apps;
    # servers = import ./servers;
    # tmux = import ./tmux;
    user = import ./user;
    # virtual = import ./virtual;
  };
in
{
  inherit ironman;
  # inherit boot config firmware networking personal-apps servers tmux virtual;
}
