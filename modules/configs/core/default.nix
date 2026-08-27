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
            bash
            boot
            fonts
            git
            homeManager
            ironman
            java
            localisation
            nix
            ssh
            sops
            topology
            userIronman
            userRoot
          ]);
        environment.systemPackages = with pkgs; [
          cifs-utils
          dig
          entr
          enum4linux
          inputs'.snowfall-flake.packages.flake
          fping
          fzf
          gcc
          glibc
          gnumake
          inetutils
          jq
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
          unrar
          unzip
          wget
          yq
          zip
        ];
        programs.mtr.enable = true;
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
    homeModules.core = { lib, pkgs, ... }: {
      imports = (
        with self.homeModules;
        [
          atuin
          bash
          bat
          btop
          direnv
          eza
          git
          gpg
          just
          nix
          nixvim
          ssh
          starship
          sops
          tealdeer
          tmux
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
          df = "${lib.getExe pkgs.duf} -only local";
          du = "${lib.getExe pkgs.dust} -xd1 --skip-total";
        };
        stateVersion = "25.05";
      };
      programs = {
        home-manager.enable = true;
        zoxide = {
          enable = true;
          enableBashIntegration = true;
        };
      };
      xdg.enable = true;
    };
  };
}
