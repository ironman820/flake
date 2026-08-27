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
      with lib;
      {
        imports = with self.nixosModules; [
          extraGuiApps
        ];
        options.ironman = {
          browser = mkOption {
            default = inputs'.zen-browser.packages.default;
            description = "Default browser to open with launchers";
            type = types.package;
          };
          laptop = mkOption {
            default = false;
            description = "Is this system a laptop?";
            type = types.bool;
          };
          terminal = mkOption {
            default = pkgs.ghostty;
            description = "Default terminal emulator to open with launchers";
            type = types.package;
          };
          user = {
            name = mkOption {
              type = types.str;
              default = "ironman";
              description = "User name to pass to other functions";
            };
            fullName = mkOption {
              type = types.str;
              default = "Nicholas Eastman";
              description = "The user's full name";
            };
            email = {
              bob = mkOption {
                type = types.str;
                default = "nicholas.m.eastman";
                description = "The user's email address";
              };
              site = mkOption {
                type = types.str;
                default = "gmail.com";
                description = "email domain";
              };
            };
          };
        };
        config =
          let
            inherit (config.ironman.user) fullName name;
          in
          {
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
      { lib, osConfig, ... }:
      let
        inherit (osConfig.ironman) laptop;
      in
      {
        imports =
          (with self.homeModules; [
            core
          ])
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
          );
        programs.tmux = lib.mkIf laptop {
          shortcut = "Space";
        };
      };
  };
}
