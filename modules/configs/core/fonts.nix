{
  flake.nixosModules.fonts = { pkgs, ... }: {
    console = {
      font = ./EnvyCodeRNerdFontMono-Regular.psf;
      useXkbConfig = true; # use xkbOptions in tty.
    };
    fonts.packages =
      (with pkgs; [
        meslo-lgs-nf
      ])
      ++ (with pkgs.nerd-fonts; [
        envy-code-r
        fira-code
        fira-mono
        inconsolata
      ]);
  };
}
