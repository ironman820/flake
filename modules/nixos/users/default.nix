{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.mine) mkOpt;
  inherit (lib.types) float str nullOr package listOf attrs;
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
      applicationOpacity = mkOpt float 0.8 "Default application opacity";
      desktopOpacity = mkOpt float 0.8 "Default desktop opacity";
      inactiveOpacity = mkOpt float 0.6 "Default inactive opacity";
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
