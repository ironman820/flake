{ channels, ... }:
final: prev: {
  barrier = prev.barrier.overrideAttrs (old: {
    postFixup = ''
      substituteInPlace "$out/share/applications/barrier.desktop" --replace "Exec=barrier" "Exec=env -u WAYLAND_DISPLAY $out/bin/barrier"
    '';
  });
}
