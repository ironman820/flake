{channels, ...}: final: prev: let
  inherit (prev.lib.lists) remove;
  inherit (prev) python3 python311;
in {
  pyright = prev.pyright.override (old: {
    buildInputs = remove python311 (remove python3 old.buildInputs);
  });
}
