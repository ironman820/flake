{ channels, ... }:

final: prev:
{
  inherit (channels.unstable) google-chrome;
}
