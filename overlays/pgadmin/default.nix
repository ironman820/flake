{ channels, ... }:
final: prev:
{
  inherit (channels.unstable) pgadmin4;
}
