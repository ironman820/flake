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
      programs = {
        starship = {
          enable = true;
          enableBashIntegration = true;
        };
        zoxide.enable = true;
      };
      services = {
        gpg-agent = {
          enable = true;
          enableScDaemon = true;
          enableSshSupport = true;
          extraConfig = ''
            ttyname $GPG_TTY
          '';
          defaultCacheTtl = 10800;
          maxCacheTtl = 21600;
        };
      };
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
