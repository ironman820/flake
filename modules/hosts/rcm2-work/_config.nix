{
  hardware.facter.reportPath = ./facter.json;
  ironman = {
    rcm2.enable = true;
    postgres = {
      enable = true;
      dbName = "rcm";
    };
    server.unattended = false;
  };
}
