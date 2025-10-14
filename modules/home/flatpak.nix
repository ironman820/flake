{
  flake.homeModules.flatpak = _: {
    ironman.just = {
      apps = [
        "flatpak --user remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo"
        "flatpak install -uy com.usebottles.bottles"
        "flatpak install -uy com.github.tchx84.Flatseal"
      ];
    };
  };
}
