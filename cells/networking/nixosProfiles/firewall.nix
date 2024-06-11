{
  cell,
  inputs,
}: {
  networking = {
    firewall = {
      enable = true;
      allowedUDPPorts = [1900];
      checkReversePath = "loose";
    };
    nftables.enable = true;
  };
}
