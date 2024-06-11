{
  cell,
  config,
  inputs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  basePath = "/etc/NetworkManager/system-connections";
  c = config.vars.networking.profiles;
  l = nixpkgs.lib // mine.lib // builtins;
  mode = "0400";
  sopsFile = ./__secrets/profiles.yaml;
in {
  options.vars.networking.profiles = {
    home = l.mkBoolOpt true "Load the home profiles";
    work = l.mkBoolOpt false "Load Work profiles";
  };

  config = {
    sops.secrets = l.mkMerge [
      (l.mkIf c.home {
        da_psk = {
          inherit mode sopsFile;
          path = "${basePath}/DumbledoresArmy.nmconnection";
        };
      })
      (l.mkIf c.work {
        office_psk = {
          inherit mode sopsFile;
          path = "${basePath}/office.nmconnection";
        };
        royell_vpn = {
          inherit mode sopsFile;
          path = "${basePath}/Royell.nmconnection";
        };
      })
    ];
  };
}
