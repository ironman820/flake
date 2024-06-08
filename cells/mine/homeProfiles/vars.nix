{
  cell,
  inputs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  l = nixpkgs.lib // mine.lib // builtins;
  t = l.types;
in {
  options.vars.applications.browser = l.mkOpt t.str "floorp" "Preferred default browser";
}
