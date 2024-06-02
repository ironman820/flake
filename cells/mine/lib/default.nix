{
  cell,
  inputs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.nixpkgs.lib) strings;
  inherit (inputs.nixpkgs.lib.types) bool;

  l = nixpkgs.lib // builtins;
in rec {
  # This block was taken from Jake Hamilton's lib declarations.
  # https://github.com/jakehamilton/config/blob/main/lib/module/default.nix
  disabled = {enable = false;};
  enabled = {enable = true;};
  ifThenElse = cond: t: f:
    if cond
    then t
    else f;
  mkOpt = type: default: description:
    l.mkOption {inherit type default description;};
  mkOpt' = type: default: mkOpt type default null;
  mkBoolOpt = mkOpt bool;
  mkBoolOpt' = mkOpt' bool;
  override-meta = meta: package:
    package.overrideAttrs (attrs: {
      meta = (attrs.meta or {}) // meta;
    });
  # End of Jake Hamilton's code
  importModules = dir:
    l.mapAttrs'
    (file: type:
      l.nameValuePair
      (l.removeSuffix ".nix" file)
      (import (dir + /${file})))
    (l.filterAttrs
      (file: type: type == "directory" || file != "default.nix")
      (l.readDir dir));
  mkNixosSystem = {
    name,
    username ? "ironman",
    system ? "x86_64-linux",
    stateVersion ? "23.05",
    nixosModules ? [],
    homeModules ? [],
  }:
    nixpkgs.lib.nixosSystem {
      inherit system;

      pkgs = nixpkgs;
      modules = nixosModules;
      # [
      #   hyprland.nixosModules.default
      #   home-manager.nixosModules.home-manager
      #   (cell.nixosModules.home homeModules)
      #   cell.nixosModules.default
      #   {system.stateVersion = stateVersion;}
      # ]
      # ++ nixosModules;

      specialArgs = {
        inherit system inputs name username;
      };
    };
  mkPxeMenu = args:
    ''
      UI menu.c32
      TIMEOUT 300
    ''
    + strings.concatStringsSep "\n" (l.mapAttrsToList
      (
        name: value: ''
          LABEL ${name}
            MENU LABEL ${value.content.label}
            KERNEL ${value.content.kernel}
            append ${value.content.append}
        ''
      )
      (l.filterAttrs (_: v: v.condition) args));
}
