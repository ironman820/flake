{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib.mine) mkBoolOpt mkOpt vars;
  inherit (lib.types) either float str nullOr package path listOf attrs;
  cfg = config.mine.user;
  defaultIconFileName = "profile.png";
  defaultIcon = pkgs.stdenvNoCC.nkderivation {
    name = "default-icon";
    src = ./. + "/${defaultIconFileName}";

    dontUnpack = true;

    installPhase = ''
      cp $src $out
    '';

    passthrough = {fileName = defaultIconFileName;};
  };
  # propogatedIcon =
  #   pkgs.runCommandNoCC "propogated-icon" {passtrhu = {inherit (cfg.icon) fileName;};}
  #   ''
  #     local target="$out/share/mine-icons/user/${cfg.name}"
  #     mkdir -p "$target"
  #
  #     cp ${cfg.icon} "$target/${cfg.icon.fileName}"
  #   '';
in {
  options.mine.user = {
    email = mkOpt str "29488820+ironman820@users.noreply.github.com" "users email";
    extraGroups =
      mkOpt (listOf str) [
      ] "Groups for the user to be assigned.";
    extraOptions =
      mkOpt attrs {}
      "Extra options passed to <option>users.users.<name></option>.";
    fullName = mkOpt str "Nicholas Eastman" "Full name of the user";
    icon =
      mkOpt (nullOr package) defaultIcon
      "The profile picture to use for the user.";
    name = mkOpt str "ironman" "Username";
    settings = {
      applications = let
        apps = vars.applications;
      in {
        browser = mkOpt str apps.browser "Default browser";
        fileManager = mkOpt str apps.fileManager "Default fileManager";
        terminal = mkOpt str apps.terminal "Default Terminal";
      };
      stylix = let
        stlx = vars.stylix;
      in {
        base16Scheme = {
          enable = mkBoolOpt stlx.base16Scheme.enable "Enable custom base 16 themes";
          package = mkOpt package pkgs.${stlx.base16Scheme.package} "Package name for color scheme";
          file = mkOpt str stlx.base16Scheme.file "file path to color scheme in package";
        };
        fonts = {
          terminalFont = mkOpt str stlx.fonts.terminalFont "Terminal font settings";
          terminalSize = mkOpt float stlx.fonts.terminalSize "Size of terminal fonts";
        };
        image = mkOpt (either path str) stlx.image "Default wallpaper image";
      };
      transparancy = let
        tsp = vars.transparancy;
      in {
        applicationOpacity = mkOpt float tsp.applicationOpacity "Default opacity for normal applications";
        desktopOpacity = mkOpt float tsp.desktopOpacity "Opacity for desktop objects like bars";
        inactiveOpacity = mkOpt float tsp.inactiveOpacity "Opacity for inactive applications";
        terminalOpacity = mkOpt float tsp.terminalOpacity "Opacity for terminal windows";
      };
    };
  };

  config = {
    users.users.${cfg.name} =
      {
        createHome = true;
        extraGroups = ["wheel"] ++ cfg.extraGroups;
        group = "users";
        home = "/home/${cfg.name}";
        isNormalUser = true;
        shell = pkgs.bash;
        uid = 1000;
      }
      // cfg.extraOptions;
  };
}
