{
  inputs,
  moduleWithSystem,
  self,
  ...
}:
{
  flake = {
    nixosModules.core = moduleWithSystem (
      perSystem@{ inputs', ... }: { pkgs, ... }: {
        imports =
          (with inputs; [ ])
          ++ (with self.nixosModules; [
            boot
            direnv
            fonts
            homeManager
            java
            localisation
            userIronman
            userRoot
            ssh
            sops
          ]);
        environment.systemPackages = with pkgs; [
          age
          btop
          cifs-utils
          delta
          diff-so-fancy
          dig
          duf
          dust
          entr
          enum4linux
          eza
          inputs'.snowfall-flake.packages.flake
          fping
          fzf
          gcc
          glibc
          gnumake
          inetutils
          jq
          just
          fastfetch
          nix-output-monitor
          nixos-anywhere
          nodejs
          ntfs3g
          nvd
          p7zip
          pciutils
          pv
          qrencode
          rclone
          ripgrep
          ssh-to-age
          sops
          tealdeer
          unrar
          unzip
          wget
          yq
          zip
        ];
        programs = {
          bash.enable = true;
          mtr.enable = true;
        };
        security.sudo.execWheelOnly = true;
        system.stateVersion = "25.05";
      }
    );
    homeConfigurations.core = {
      imports = (
        with self.homeModules;
        [
          core
        ]
      );
    };
    homeModules.core = moduleWithSystem (
      perSystem@{ ... }:
      _: {
        imports = (
          with self.homeModules;
          [
            bat
            direnv
            nixvim
            ssh
            sops
          ]
        );
        home = {
          sessionPath = [
            "$HOME/bin"
            "$HOME/.local/bin"
          ];
          shellAliases = {
            ".." = "cd ..";
            "..." = "cd ../..";
            "...." = "cd ../../..";
          };
          stateVersion = "25.05";
        };
        programs = {
          bash.enable = true;
          home-manager.enable = true;
        };
        xdg.enable = true;
      }
    );
  };
}
