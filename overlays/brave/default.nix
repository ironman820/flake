{ channels, ... }:
final: prev:
{
  inherit (channels.unstable) brave;
}
