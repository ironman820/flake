{
  hardware.facter.reportPath = ./facter.json;
  ironman = {
    rcm2 = {
      enable = true;
      domain = "desk";
    };
    server.unattended = false;
  };
  services = {
    postgresql = {
      enable = true;
      ensureDatabases = [
        "rcm"
      ];
      ensureUsers = [
        {
          ensureDBOwnership = true;
          name = "rcm";
        }
      ];
    };
  };
}
