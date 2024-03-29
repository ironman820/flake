{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.mine) mkOpt vars;
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
    initialPassword =
      mkOpt str "password"
      "The initial password to use when the user is first created.";
    name = mkOpt str "ironman" "Username";
    passFile = mkOpt str "" "Password File Path";
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
          package = mkOpt str stlx.base16Scheme.package "Package name for color scheme";
          file = mkOpt str stlx.base16Scheme.file "file path to color scheme in package";
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
        isNormalUser = true;
        home = "/home/${cfg.name}";
        group = "users";
        initialPassword = mkIf (builtins.stringLength cfg.initialPassword > 0) cfg.initialPassword;
        passwordFile = mkIf (builtins.stringLength cfg.passFile > 0) cfg.passFile;
        shell = pkgs.bash;
        uid = 1000;
        extraGroups = ["wheel"] ++ cfg.extraGroups;
      }
      // cfg.extraOptions;
  };
}
