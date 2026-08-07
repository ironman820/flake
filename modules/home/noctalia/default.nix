{ inputs, self, ... }: {
  flake.homeModules.noctalia = _: {
    programs.noctalia = {
      enable = true;
      settings = ./noctalia.toml;
    };
  };
}
