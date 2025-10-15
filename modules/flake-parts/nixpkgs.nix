{ inputs, flakeRoot, withSystem, ... }:
{
  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
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
        local = config.packages;
      }
    );
}
