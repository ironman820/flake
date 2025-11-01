{
  flakeRoot,
  inputs,
  lib,
  config,
  ...
}:
let
  prefix = "hosts/";
  collectHostsModules = modules: lib.filterAttrs (name: _: lib.hasPrefix prefix name) modules;
in
{
  easy-hosts.shared = {
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
  flake.nixosConfigurations = lib.pipe (collectHostsModules config.flake.nixosModules) [
    (lib.mapAttrs' (
      name: module:
      let
        specialArgs = {
          inherit flakeRoot inputs;
          hostConfig = module // {
            name = lib.removePrefix prefix name;
          };
        };
      in
      {
        name = lib.removePrefix prefix name;
        value = inputs.nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules =
            module.imports
            ++ (with inputs; [
              darkmatter-grub-theme.nixosModule
              disko.nixosModules.disko
              home-manager.nixosModules.home-manager
              {
                home-manager.extraSpecialArgs = specialArgs;
              }
              neovim.nixosModules.default
              sops-nix.nixosModules.sops
            ]);
        };
      }
    ))
  ];
}
