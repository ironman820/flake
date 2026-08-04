{
  flakeRoot,
  inputs,
  self,
  ...
}:
{
  easy-hosts = {
    autoConstruct = true;
    onlySystem = "x86_64-nixos";
    path = ../../hosts;
    shared = {
      modules = with inputs; [
        home-manager.nixosModules.home-manager
        {
          home-manager.extraSpecialArgs = {
            inherit flakeRoot;
          };
        }
        self.nixosModules.base
      ];
      specialArgs = {
        inherit flakeRoot;
      };
    };
  };
}
