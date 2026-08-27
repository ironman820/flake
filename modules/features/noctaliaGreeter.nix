{
  inputs,
  ...
}:
{
  flake = {
    nixosModules.noctaliaGreeter = { config, ... }: {
      imports = [
        inputs.noctalia-greeter.nixosModules.default
      ];
      programs.noctalia-greeter = {
        enable = true;
        settings = {
          appearance = {
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
  };
}
