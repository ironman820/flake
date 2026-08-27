{
  flake.nixosModules.boot = { config, lib, ... }: {
    options.ironman.grub = lib.mkOption {
      default = true;
      description = "Enable Grub for this machine?";
      type = lib.types.bool;
    };
    config =
      let
        inherit (config) ironman;
        inherit (lib) mkDefault;
      in
      {
        boot = {
          kernelParams = [
            "quiet"
          ];
          loader = {
            efi.canTouchEfiVariables = true;
            grub = {
              enable = ironman.grub;
              efiSupport = true;
              device = "nodev";
              splashImage = null;
              timeoutStyle = "hidden";
            };
            systemd-boot = {
              enable = mkDefault (!ironman.grub);
              configurationLimit = 5;
            };
          };
          plymouth.enable = mkDefault ironman.grub;
        };
      };
  };
}
