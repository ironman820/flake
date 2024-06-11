{
  cell,
  inputs,
  pkgs,
}: {
  environment.systemPackages = [
    pkgs.floorp
  ];
}
