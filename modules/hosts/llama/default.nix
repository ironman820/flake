{
  config,
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
          users.ironman = config.flake.homeConfigurations.ironman-server;
        };
      }
    ]
    ++ (with config.flake.nixosModules; [
      base
      llama-hardware
      proxmox
      virtual-docker
      x64-linux
    ]);
  };
}
