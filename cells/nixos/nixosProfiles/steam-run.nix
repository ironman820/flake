{
  cell,
  inptus,
  pkgs,
}: {
  environment.systemPackages = with pkgs; [
    steam-run
  ];
}
