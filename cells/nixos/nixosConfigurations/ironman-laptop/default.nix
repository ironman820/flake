{
  cell,
  inputs,
  ...
}: let
  inherit (inputs) haumea nixpkgs;
  inherit (inputs.cells) mine;
  l = nixpkgs.lib // haumea.lib // mine.lib // builtins;
in
  l.mkNixosSystem {
    name = "ironman-laptop";
    nixosModules = l.importModules ./__hardware.nix;
    # [
    # (import ../../disko.nix
    #   {device = "/dev/nvme0n1";})
    # ./__hardware.nix
    # ../../../common/drives/personal.nix
    # ];

    # config = {
    #   # mine = {
    #   #   android = enabled;
    #   #   gui-apps.hexchat = enabled;
    #   #   suites.laptop = enabled;
    #   #   user.settings.stylix.image = ./ffvii.jpg;
    #   #   networking.profiles.work = true;
    #   # };
    #   # environment.systemPackages = [
    #   #   pkgs.devenv
    #   # ];
    #   services.tlp.settings.RUNTIME_PM_DISABLE = "02:00.0";
    #   zramSwap = l.enabled;
    # };
  }
