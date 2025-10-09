# Snowfall Lib provides access to your current Nix channels and inputs.
#
# Channels are named after NixPkgs instances in your flake inputs. For example,
# with the input `nixpkgs` there will be a channel available at `channels.nixpkgs`.
# These channels are system-specific instances of NixPkgs that can be used to quickly
# pull packages into your overlay.
#
# All other arguments for this function are your flake inputs.
{channels, ...}: final: prev: {
  inherit (channels.unstable) linux-firmware;
}
