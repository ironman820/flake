{
  cell,
  config,
  inputs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  c = config.networking.firewall;
  l = nixpkgs.lib // mine.lib // builtins;
in {
  networking.firewall = l.mkIf c.enable {
    allowedTCPPorts = [
      8291
    ];
    allowedUDPPorts = [
      5678
      20561
    ];
  };
}
