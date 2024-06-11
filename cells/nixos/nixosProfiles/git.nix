{
  cell,
  inputs,
  pkgs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  l = nixpkgs.lib // mine.lib // builtins;
in {
  environment.systemPackages = with pkgs; [
    # catppuccin-lazygit
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
    lfs = l.enabled;
    prompt = l.enabled;
  };
}
