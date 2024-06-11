{
  cell,
  inputs,
  pkgs,
}: {
  environment.systemPackages = [pkgs.tealdeer];
}
