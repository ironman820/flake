{ channels, ... }:
final: prev:
{
  inherit (channels.unstable) qtile;
  inherit (channels.unstable.pythonPackages) qtile-extras;
}
