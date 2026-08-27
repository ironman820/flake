{
  moduleWithSystem,
  ...
}:
{
  flake = moduleWithSystem (
    perSystem@{ inputs', ... }:
    {
      nixosModules.ironman =
        { lib, pkgs, ... }:
        let
          inherit (lib) mkOption;
          inherit (lib.types) bool package;
        in
        {
          options.ironman = {
            browser = mkOption {
              default = inputs'.zen-browser.packages.default;
              description = "Default browser to open with launchers";
              type = package;
            };
            laptop = mkOption {
              default = false;
              description = "Is this system a laptop?";
              type = bool;
            };
            terminal = mkOption {
              default = pkgs.ghostty;
              description = "Default terminal emulator to open with launchers";
              type = package;
            };
          };
        };
      homeModules.ironman = {
      };
    }
  );
}
