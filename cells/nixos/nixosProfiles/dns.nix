{
  cell,
  config,
  inputs,
}: {
  networking.firewall = {
    allowedTCPPorts = [
      53
    ];
    allowedUDPPorts = [
      53
    ];
  };
}
