{ channels, my-input, ... }:

final: prev: {
    inherit (channels.unstable) github-desktop;
}
