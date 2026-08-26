{
  inputs,
  self,
  ...
}:
{
  flake.homeModules.base =
    {
      imports =
        (with self.homeModules; [
          ironman
        ])
        ++ (with inputs; [
          nix-flatpak.homeManagerModules.nix-flatpak
          noctalia.homeModules.default
          plasma-manager.homeModules.plasma-manager
        ]);
      xdg = {
        configFile = {
          "tealdeer/config.toml".text = ''
            [updates]
            auto_update = true
          '';
        };
      };
    };
}
