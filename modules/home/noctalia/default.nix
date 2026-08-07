{
  flake.homeModules.noctalia = { config, ... }: {
    ironman.lazygit_config_files = [
      "${config.xdg.configHome}/lazygit/themes/noctalia.yml"
    ];
    programs = {
      bat.config.theme = "noctalia";
      btop.settings.color_theme = "noctalia";
      ghostty.settings.theme = "noctalia";
      noctalia = {
        enable = true;
        settings = ./noctalia.toml;
      };
      zed-editor.userSettings.theme = "Noctalia Dark";
    };
  };
}
