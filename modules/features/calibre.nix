{
  inputs,
  ...
}:
{
  perSystem =
    {
      # config,
      self',
      # inputs',
      pkgs,
      # system,
      ...
    }:
    {
      apps.calibre = {
        meta.description = "";
        program = self'.packages.calibre;
      };
      packages.calibre = pkgs.calibre.override {
        unrarSupport = true;
      };
    };
}
