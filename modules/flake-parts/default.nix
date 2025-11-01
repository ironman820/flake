{inputs, ...}: {
  imports = with inputs; [
    disko.flakeModules.default
    easy-hosts.flakeModule
    home-manager.flakeModules.home-manager
    pkgs-by-name.flakeModule
  ];
  systems = [
    "x86_64-linux"
  ];
}
