{ channels, ... }:
final: prev:
{
  nixGLDefault = prev.nixGLDefault.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      ./nixgl-purity.patch
    ];
  });
}
