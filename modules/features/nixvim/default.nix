{
  inputs,
  self,
  ...
}:
{
  flake = {
    nixosModules.nixvim =
      {
        config,
        pkgs,
        ...
      }:
      {
        imports = [
          inputs.nixvim.nixosModules.nixvim
          self.nixosModules.nixvimOptions
        ];
        environment.shellAliases.nv = "nvim";
        programs.nixvim =
          let
            cfg = (
              import ./_nixvim.nix {
                inherit pkgs;
                config = config // {
                  ironman.neovimPkg = false;
                };
              }
            );
          in
          {
            enable = true;
            defaultEditor = true;
          }
          // cfg;
      };
    homeModules.nixvim =
      {
        config,
        pkgs,
        ...
      }:
      {
        imports = [
          inputs.nixvim.homeModules.nixvim
          self.homeModules.nixvimOptions
        ];
        home = {
          sessionVariables.EDITOR = "nvim";
          shellAliases.nv = "nvim";
        };
        programs.nixvim =
          let
            cfg = (
              import ./_nixvim.nix {
                inherit pkgs;
                config = config // {
                  ironman.neovimPkg = false;
                };
              }
            );
          in
          {
            enable = true;
            defaultEditor = true;
          }
          // cfg;
      };
  };
  perSystem =
    {
      self',
      system,
      ...
    }:
    {
      apps.neovim = {
        meta.description = "Neovim (nixvim) configured editor";
        program = self'.packages.neovim;
      };
      packages.neovim =
        (inputs.nixvim.lib.evalNixvim {
          inherit system;
          modules = [
            self.nixosModules.nixvimOptions
            ./_nixvim.nix
          ];
        }).config.build.package;
    };
}
