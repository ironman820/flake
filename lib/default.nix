{lib, ...}: let
  inherit (lib) mkOption;
  inherit (lib.types) bool;
in rec {
  disabled = {enable = false;};
  enabled = {enable = true;};
  ifThenElse = cond: t: f:
    if cond
    then t
    else f;
  mkOpt = type: default: description:
    mkOption {inherit type default description;};
  mkOpt' = type: default: mkOpt type default null;
  mkBoolOpt = mkOpt bool;
  mkBoolOpt' = mkOpt' bool;
}
