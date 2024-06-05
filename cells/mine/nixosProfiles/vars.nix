{
  cell,
  config,
  inputs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  l = nixpkgs.lib // mine.lib // builtins;
  cfg = config.vars;
in {
  options.vars = {
    username = l.mkOpt l.types.str "ironman" "Default username";
  };
  config.users.users.${cfg.username}.isNormalUser = true;
}
