{
  flake.nixosModules.noctalia-greeter = { config, ... }: {
    programs.noctalia-greeter = {
      enable = true;
      settings = {
        appearance = {
          hide_logo = true;
          password_style = "random";
          scheme = "Tokyo-Night";
          theme_mode = "dark";
        };
        idle.timeout = 300;
        keyboard.layout = "us";
        session.default = "niri";
        user.default = config.ironman.user.name;
      };
    };
  };
}
