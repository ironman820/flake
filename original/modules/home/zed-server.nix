{
  flake.homeModules.zed-server = {
    programs.zed-editor = {
      enable = true;
      installRemoteServer = true;
    };
  };
}
