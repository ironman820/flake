{
  flake.homeModules.flatpak = _: {
    services.flatpak = {
      enable = true;
      packages = [
        "com.usebottles.bottles"
        "com.github.tchx84.Flatseal"
      ];
      uninstallUnmanaged = true;
      update.auto = {
        enable = true;
        onCalendar = "weekly";
      };
    };
  };
}
