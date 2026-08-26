{
  flake.homeModules.flatpak = _: {
    services.flatpak = {
      enable = true;
      packages = [
        "com.usebottles.bottles"
        "com.github.tchx84.Flatseal"
        "com.orcaslicer.OrcaSlicer"
      ];
      uninstallUnmanaged = true;
      update.onActivation = true;
    };
  };
}
