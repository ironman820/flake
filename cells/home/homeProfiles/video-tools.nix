{
  cell,
  config,
  inputs,
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
        nixpkgs.ffmpeg
      ]
      (l.mkIf c.handbrake [
        nixpkgs.handbrake
      ])
    ];
  };
}
