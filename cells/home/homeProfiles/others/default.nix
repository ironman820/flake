{
  cell,
  config,
  inputs,
}: let
  c = config.vars.applications;
in {
  home = {
    file."putty/sessions/FS Switch".source = ./__config/putty/${"FS%20Switch"};
    sessionVariables = {BROWSER = c.browser;};
  };
  services.udiskie = {
    enable = true;
    tray = "never";
  };
}
