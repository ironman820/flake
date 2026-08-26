{ inputs, self, ... }: {
  imports = [
    inputs.disko.nixosModules.disko
    self.diskoConfigurations.friday
  ];
  hardware.facter.reportPath = ./facter.json;
}
