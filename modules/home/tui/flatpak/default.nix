{
  config,
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.mine) mkBoolOpt;

  cfg = config.mine.home.tui.flatpak;
  imp = config.mine.home.impermanence.enable;
  os = osConfig.mine.tui.flatpak;
in {
  options.mine.home.tui.flatpak = {
    enable = mkBoolOpt os.enable "Enable the module";
  };
  config = mkIf cfg.enable {
    mine.home.tui.just = {
      apps = [
        "flatpak --user remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo"
        "flatpak install -uy com.usebottles.bottles"
        "flatpak install -uy com.github.tchx84.Flatseal"
        "flatpak install -uy org.gnome.gitlab.YaLTeR.VideoTrimmer"
      ];
      homePersist = mkIf imp [
        "mkdir -p /persist/home/.local/share/flatpak"
      ];
    };
    home.persistence."/persist/home".directories = mkIf imp [
      ".local/share/flatpak"
    ];
  };
}
