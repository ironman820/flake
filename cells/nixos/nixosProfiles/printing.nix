{
  cell,
  inputs,
  pkgs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  l = nixpkgs.lib // mine.lib // builtins;
in {
  programs.system-config-printer = l.enabled;
  services = {
    avahi = l.enabled;
    printing = {
      enable = true;
      cups-pdf = l.enabled;
      drivers = with pkgs; [gutenprint hplip];
    };
  };
}
