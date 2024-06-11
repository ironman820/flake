{
  cell,
  inputs,
  pkgs,
}: {
  environment.systemPackages = [pkgs.just];
}
