{
  cell,
  inputs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells.mine.packages) base16-onedark-scheme;
in {
  stylix = {
    base16Scheme = "${base16-onedark-scheme}/theme.yaml";
    cursor = {
      package = nixpkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };
    fonts = {
      monospace = {
        name = "FiraCode Nerd Font Mono";
        package = nixpkgs.nerdfonts;
      };
      sansSerif = {
        name = "DejaVuSansM Nerd Font";
        package = nixpkgs.nerdfonts;
      };
      serif = {
        name = "FiraCode Nerd Font";
        package = nixpkgs.nerdfonts;
      };
    };
    homeManagerIntegration = {
      autoImport = false;
      followSystem = true;
    };
    image = ./no-place-like-homeV6.jpg;
    opacity = {
      applications = 1.0;
      desktop = 0.0;
      popups = 0.9;
      terminal = 0.6;
    };
    polarity = "dark";
  };
}
