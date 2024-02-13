{ channels, ... }:
final: prev: {
  steam = prev.steam.override ({ extraPkgs ? pkgs': [], ... }: {
    extraPkgs = pkgs': (extraPkgs pkgs') ++ (with pkgs'; [
      libgdiplus
    ]);
  });
}
