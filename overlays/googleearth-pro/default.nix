{ channels, ... }:
final: prev:
{
  inherit (channels.unstable) googleearth-pro;
}
