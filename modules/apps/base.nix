{ config, ... }:
{
  flake.nixosModules.apps-base =
    { pkgs, ... }:
    {
      imports = with config.flake.nixosModules; [
        apps-python
        tmux
      ];
      environment.systemPackages =
        with pkgs;
        [
          # catppuccin-lazygit
          cifs-utils
          diff-so-fancy
          dig
          duf
          du-dust
          eltclsh
          enum4linux
          ffmpeg
          fzf
          gcc
          gh
          git
          git-filter-repo
          github-cli
          glab
          glibc
          gnumake
          hplip
          # idracclient
          inetutils
          jq
          just
          lazygit
          neofetch
          nodejs
          ntfs3g
          p7zip
          poppler_utils
          pv
          qrencode
          restic
          rclone
          ripgrep
          # switchssh
          tealdeer
          trashy
          unzip
          wireguard-tools
          yq
          zip
        ]
        ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
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
