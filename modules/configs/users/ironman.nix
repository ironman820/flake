{
  self,
  ...
}:
{
  flake = {
    nixosModules.userIronman =
      { config, lib, ... }:
      with lib;
      {
        options.ironman.user = {
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
      };
    homeConfigurations.ironman = {
      imports = (
        with self.homeModules;
        [
          core
          extraGuiApps
        ]
      );
    };
  };
}
