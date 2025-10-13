{
  flake.nixosModules.resilio = _: {
    services.resilio = {
      enable = true;
      checkForUpdates = false;
      enableWebUI = true;
    };
  };
}
