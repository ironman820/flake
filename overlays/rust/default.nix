{ channels, ... }:
final: prev:
{
  inherit (channels.unstable) cargo rustc;
}
