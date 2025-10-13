{ config, ... }:
{
  flake.nixosModules.apps-base =
    { pkgs, ... }:
    {
      imports = with config.flake.nixosModules; [
        apps-python
        tmux
      ];
      environment.systemPackages = with pkgs; [
        # catppuccin-lazygit
        cifs-utils
        diff-so-fancy
        enum4linux
        gcc
        gh
        git
        git-filter-repo
        github-cli
        glab
        glibc
        gnumake
        hplip
        just
        lazygit
        ntfs3g
        tealdeer
        wireguard-tools
      ];
      nixCats.enable = true;
      programs = {
        git = {
          enable = true;
          lfs.enable = true;
          prompt.enable = true;
        };
        java = {
          binfmt = true;
          enable = true;
          package = pkgs.jdk;
        };
      };
    };
}
