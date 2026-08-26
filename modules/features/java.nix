{
  flake.nixosModules.java = { pkgs, ... }: {
    programs.java = {
      binfmt = true;
      enable = true;
      package = pkgs.jdk;
    };
  };
}
