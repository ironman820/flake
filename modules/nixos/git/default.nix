{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.mine) enabled mkBoolOpt;

  cfg = config.mine.git;
in {
  options.mine.git = {enable = mkBoolOpt true "Setup git";};

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      catppuccin-lazygit
      diff-so-fancy
      git
      git-filter-repo
      github-cli
      gh
      glab
      lazygit
    ];
    programs.git = {
      enable = true;
      lfs = enabled;
      prompt = enabled;
    };
  };
}
