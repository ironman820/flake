{
  cell,
  config,
  inputs,
  pkgs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  l = nixpkgs.lib // mine.lib // builtins;
  v = config.vars;
in {
  vars = l.mkIf (v ? "gpg") {
    gpg.pinentryPackage = "qt";
  };
  environment = {
    sessionVariables.NIXOS_OZONE_WL = "1";
    systemPackages =
      (with pkgs; [
        blueman
        bluez
        bluez-tools
        breeze-icons
        brightnessctl
        cliphist
        eza
        figlet
        freerdp
        gnome.adwaita-icon-theme
        gtk4
        grim
        gum
        hyprland
        hyprpaper
        libnotify
        man-pages
        meson
        mpv
        nwg-look
        pavucontrol
        pfetch
        polkit_gnome
        pulseaudio
        qt6.qtwayland
        rofi-wayland
        rsync
        slurp
        swappy
        swaylock-effects
        unzip
        vlc
        waybar
        wayland-protocols
        wayland-utils
        wget
        wl-clipboard
        wlroots
        xwayland
        zathura
      ])
      ++ (with pkgs.libsForQt5; [
        polkit-kde-agent
        qt5.qtwayland
      ])
      ++ (with pkgs.xfce; [
        mousepad
        tumbler
      ]);
  };
  nix.settings = {
    extra-substituters = [
      "https://hyprland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };
  programs = {
    dconf = l.enabled;
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.hyprland;
      xwayland = l.enabled;
    };
  };
  security.pam.services.swaylock = {};
  services = {
    dbus = l.enabled;
    xserver = {
      enable = true;
      xkb.layout = "us";
    };
  };
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gtk
    xdg-desktop-portal-wlr
  ];
}
