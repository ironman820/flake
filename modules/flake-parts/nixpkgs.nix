{
  inputs,
  flakeRoot,
  withSystem,
  ...
}:
{
  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          inputs.rust-overlay.overlays.default
          inputs.self.overlays.default
        ];
      };
      pkgsDirectory = flakeRoot + "/packages";
    };
  flake.overlays.default =
    final: prev:
    withSystem prev.stdenv.hostPlatform.system (
      { config, ... }:
      {
        inherit (inputs.nixpkgs-stable.legacyPackages.${prev.stdenv.hostPlatform.system}) wireshark;
        local = config.packages;
      }
    );
}
