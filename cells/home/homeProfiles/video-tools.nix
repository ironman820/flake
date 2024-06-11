{
  cell,
  config,
  inputs,
  pkgs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  c = config.vars.applications;
  l = nixpkgs.lib // mine.lib // builtins;
in {
  options.vars.applications = {
    handbrake = l.mkBoolOpt false "Install Handbrake";
  };

  config = {
    home.packages = l.mkMerge [
      [
        pkgs.ffmpeg
      ]
      (l.mkIf c.handbrake [
        pkgs.handbrake
      ])
    ];
  };
}
