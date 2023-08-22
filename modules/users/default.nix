{ pkgs, config, lib, ... }:

with lib;
# with lib.internal;
let
  cfg = config.ironman.user;
  defaultIconFileName = "profile.png";
  defaultIcon = pkgs.stdenvNoCC.nkderivation {
    name = "default-icon";
    src = ./. + "/${defaultIconFileName}";

    dontUnpack = true;

    installPhase = ''
      cp $src $out
    '';

    passthrough = { fileName = defaultIconFileName; };
  };
  propogatedIcon = pkgs.runCommandNoCC "propogated-icon" { passtrhu = { fileName = cfg.icon.fileName; }; }
    ''
      local target="$out/share/ironman-icons/user/${cfg.name}"
      mkdir -p "$target"

      cp ${cfg.icon} "$target/${cfg.icon.fileName}"
    '';
in
{
  options.ironman.user = with types; {
    name = mkOpt str "ironman" "The name to use for the user account.";
    fullName = mkOpt str "Nicholas Eastman" "The full name of the user.";
    email = mkOpt str "29488820+ironman820@users.noreply.github.com" "The email of the user.";
    initialPassword = mkOpt str "password"
      "The initial password to use when the user is first created.";
    passFile = mkOpt str "" "Password File Path";
    icon = mkOpt (nullOr package) defaultIcon
      "The profile picture to use for the user.";
    extraGroups = mkOpt (listOf str) [
    ] "Groups for the user to be assigned.";
    extraOptions = mkOpt attrs { }
      "Extra options passed to <option>users.users.<name></option>.";
  };

  config = {
    users.users.${cfg.name} = {
      isNormalUser = true;
      home = "/home/${cfg.name}";
      group = "users";
      initialPassword = mkIf (builtins.stringLength cfg.initialPassword > 0) cfg.initialPassword;
      passwordFile = mkIf (builtins.stringLength cfg.passFile > 0) cfg.passFile;
      shell = pkgs.bash;
      uid = 1000;
      extraGroups = [ "wheel" ] ++ cfg.extraGroups;
    } // cfg.extraOptions;
  };
}
