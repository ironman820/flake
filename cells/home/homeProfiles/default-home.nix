{
  cell,
  inputs,
  pkgs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) idracclient mine;
  l = nixpkgs.lib // mine.lib // builtins;
  p = mine.packages // idracclient.packages;
in {
  home = {
    packages = with pkgs; [
      dig
      duf
      du-dust
      eltclsh
      fzf
      p.idracclient
      inetutils
      jq
      neofetch
      nerdfonts
      nodejs_18
      p7zip
      poppler_utils
      pv
      qrencode
      restic
      rclone
      ripgrep
      p.switchssh
      unzip
      yq
      zip
    ];
    sessionPath = ["$HOME/bin" "$HOME/.local/bin"];
    shellAliases = {
      "df" = "duf -only local";
      "du" = "dust -xd1 --skip-total";
      "ducks" = "du -chs * 2>/dev/null | sort -rh | head -11 && du -chs .* 2>/dev/null | sort -rh | head -11";
      "gmount" = "rclone mount google:/ ~/Drive/";
      "htop" = "btop";
    };
    stateVersion = "23.05";
  };
  programs = {
    atuin = {
      enable = true;
      flags = ["--disable-up-arrow"];
    };
    bash = {
      enable = true;
      enableCompletion = true;
      enableVteIntegration = true;
    };
    btop = {
      enable = true;
      settings.vim_keys = true;
    };
    dircolors = l.enabled;
    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv = l.enabled;
    };
    eza = {
      enable = true;
      extraOptions = ["--group-directories-first" "--header"];
      git = true;
      icons = true;
    };
    home-manager = l.enabled;
    starship = {
      enable = true;
      enableBashIntegration = true;
    };
    zoxide = l.enabled;
  };
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };
}
