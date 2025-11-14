{
  flakeRoot,
  inputs,
  ...
}:
{
  easy-hosts = {
    autoConstruct = true;
    path = ../../hosts;
    shared = {
      modules = with inputs; [
        home-manager.nixosModules.home-manager
        {
          home-manager.extraSpecialArgs = {
            inherit flakeRoot;
          };
        }
        neovim.nixosModules.default
        sops-nix.nixosModules.sops
      ];
      specialArgs = {
        inherit flakeRoot;
      };
    };
  };
}
