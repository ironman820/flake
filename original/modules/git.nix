{
  flake.nixosModules.git =
    { lib, pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        gh
        git-extras
        git-filter-repo
        github-cli
      ];
      programs = {
        git = {
          enable = true;
          lfs.enable = true;
          prompt.enable = lib.mkDefault true;
        };
        lazygit.enable = true;
      };
    };
}
