{ self, ... }:
{
  flake.homeConfigurations.ironman = {
    imports =
      (with self.homeModules; [
        base
        extra
        flatpak
        niri
        python
        qt
        syncthing
      ]);
    programs = {
      niri.settings.switch-events.lid-close.action.spawn = [
        "noctalia"
        "msg"
        "session"
        "lock-and-suspend"
      ];
      tmux.shortcut = "Space";
    };
  };
}
