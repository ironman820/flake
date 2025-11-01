{
  config,
  flakeRoot,
  inputs,
  ...
}:
{
  easy-hosts.hosts.llama = {
    arch = "x86_64";
    deployable = true;
    modules = [
      ./_configuration.nix
      {
        home-manager = {
          extraSpecialArgs = {
            inherit flakeRoot;
          };
          users.ironman = config.flake.homeConfigurations.ironman-server;
        };
      }
    ]
    ++ (with inputs; [
      home-manager.nixosModules.home-manager
      neovim.nixosModules.default
      sops-nix.nixosModules.sops
    ])
    ++ (with config.flake.nixosModules; [
      base
      llama-hardware
      proxmox
      virtual-docker
      x64-linux
    ]);
  };
}
