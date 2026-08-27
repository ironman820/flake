{
  self,
  moduleWithSystem,
  ...
}:
{
  flake = {
    nixosModules.userIronman = moduleWithSystem (
      perSystem@{ inputs', ... }:
      {
        config,
        lib,
        pkgs,
        ...
      }:
      let
        inherit (lib) mkOption;
        inherit (lib.types) bool package str;
      in
      {
        imports = with self.nixosModules; [
          extraGuiApps
        ];
        options.ironman = {
          browser = mkOption {
            default = inputs'.zen-browser.packages.default;
            description = "Default browser to open with launchers";
            type = package;
          };
          laptop = mkOption {
            default = false;
            description = "Is this system a laptop?";
            type = bool;
          };
          netbook = mkOption {
            default = false;
            description = "Is this system a netbook";
            type = bool;
          };
          terminal = mkOption {
            default = pkgs.ghostty;
            description = "Default terminal emulator to open with launchers";
            type = package;
          };
          user = {
            name = mkOption {
              type = str;
              default = "ironman";
              description = "User name to pass to other functions";
            };
            fullName = mkOption {
              type = str;
              default = "Nicholas Eastman";
              description = "The user's full name";
            };
            email = {
              bob = mkOption {
                type = str;
                default = "nicholas.m.eastman";
                description = "The user's email address";
              };
              site = mkOption {
                type = str;
                default = "gmail.com";
                description = "email domain";
              };
            };
          };
          workWorkstation = mkOption {
            default = false;
            description = "If this machine is a work workstation.";
            type = bool;
          };
        };
        config =
          let
            inherit (config.ironman) laptop netbook;
            inherit (config.ironman.user) fullName name;
          in
          {
            assertions = [
              {
                assertion = !(laptop && netbook);
                message = "For the sake of this configuration, a system CAN NOT be a laptop and a netbook at the same time. Please disable one of those options.";
              }
            ];
            home-manager.users.${name} = self.homeConfigurations.ironman;
            users.groups.${name} = {
              gid = 1000;
            };
            users.users.${name} = {
              group = name;
              isNormalUser = true;
              createHome = true;
              description = fullName;
              extraGroups = [
                "dialout"
                "users"
                "wheel"
              ];
              home = "/home/${name}";
              initialPassword = "@ppl3Sauc3";
              openssh.authorizedKeys.keys = [
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL3Ue/VoEgGG4nzoW3jpiwlnmWApkUyu/j1VmEwiSdy7"
              ];
              uid = 1000;
            };
          };
      }
    );
    homeConfigurations.ironman =
      {
        lib,
        osConfig,
        pkgs,
        ...
      }:
      let
        inherit (lib) mkIf;
        inherit (osConfig.ironman) laptop netbook workWorkstation;
      in
      {
        imports = [
          self.homeModules.core
        ]
        ++ (
          if laptop then
            (with self.homeModules; [
              extraGuiApps
              flatpak
              ghostty
              niri
              syncthing
              yubikey
            ])
          else
            [ ]
        )
        ++ (
          if netbook then
            (with self.homeModules; [
              extraGuiApps
              flatpak
              ghostty
              syncthing
              xfce
              yubikey
            ])
          else
            [ ]
        );
        home.packages = mkIf workWorkstation (
          with pkgs;
          [
            qgis
            wireshark
            zoom-us
          ]
        );
        programs.tmux = mkIf laptop {
          shortcut = "Space";
        };
      };
  };
}
