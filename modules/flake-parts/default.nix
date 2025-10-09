{inputs, ...}: {
  imports = [
    inputs.disko.flakeModules.default
  ];
  systems = [
    "x86_64-linux"
  ];
}
