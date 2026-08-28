{ inputs, ... }: {
  flake = {
    nixosModules.cosmic = {
      services = {
        desktopManager.cosmic.enable = true;
        displayManager.cosmic-greeter.enable = true;
        system76-scheduler.enable = true;
      };
    };
    homeModules.cosmic = {
      imports = [
        inputs.cosmic-manager.homeManagerModules.cosmic-manager
      ];
    };
  };
}
