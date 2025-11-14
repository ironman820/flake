{
  flake.nixosModules.ironman =
    {
      config,
      lib,
      options,
      pkgs,
      ...
    }:
    with lib;
    {
      options.ironman = {
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
              default = "!!USER@DOMAIN!!";
              description = "The user's email address";
            };
            site = mkOption {
              type = types.str;
              default = "";
              description = "email domain";
            };
          };
        };
        drive-shares = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = "AutoFS autoMaster share declarations";
        };
        syncthing = {
          cert = mkOption {
            default = null;
            type = types.nullOr types.path;
          };
          devices = mkOption {
            default = { };
            type = types.attrs;
          };
          folders = mkOption {
            default = { };
            type = types.attrs;
          };
          key = mkOption {
            default = null;
            type = types.nullOr types.path;
          };
        };
      };
      config =
        let
          inherit (config.ironman.user) fullName name;
        in
        {
          ironman.user.email = {
            bob = lib.mkDefault "nicholas.m.eastman";
            site = lib.mkDefault "gmail.com";
          };
          services.autofs.autoMaster = strings.concatStringsSep "\n" (
            lists.flatten (mkAliasDefinitions options.ironman.drive-shares).content.contents
          );
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
            shell = pkgs.bash;
            uid = 1000;
          };
        };
    };
}
