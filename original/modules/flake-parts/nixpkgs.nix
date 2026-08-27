{
  inputs,
  ...
}:
{
  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = with inputs; [
          # noctalia.overlays.default
          rust-overlay.overlays.default
        ];
      };
    };
}
