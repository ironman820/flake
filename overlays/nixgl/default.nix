{ channels, ... }:
final: prev:
{
  nixgl.auto.nixGLDefault = prev.nixgl.auto.nixGLDefault.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      ./nixgl-purity.patch
    ];
  });
}
