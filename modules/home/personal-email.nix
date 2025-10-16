{
  flake.homeModules.personal-email =
    {
      config,
      lib,
      osConfig,
      ...
    }:
    let
      inherit (osConfig.ironman) user;
    in
    {
      accounts.email.accounts.personal = {
        enable = true;
        address = lib.strings.concatStringsSep "@" [
          user.email.bob
          user.email.site
        ];
        flavor = "gmail.com";
        lieer = {
          enable = true;
          sync.enable = true;
        };
        neomutt = {
          enable = true;
          sendMailCommand = "gmi send -t -C ${config.home.homeDirectory}/Maildir/personal";
          showDefaultMailbox = false;
        };
        notmuch = {
          enable = true;
          neomutt = {
            enable = true;
            virtualMailboxes = [
              {
                name = "Inbox";
                query = "tag:inbox";
              }
              {
                name = "Archive";
                query = "not tag:inbox and not tag:spam";
              }
              {
                name = "Sent";
                query = "tag:sent";
              }
            ];
          };
        };
        # passwordCommand = "cat ${config.sops.secrets.work-email-password.path}";
        primary = lib.mkDefault true;
        realName = user.fullName;
        # signature = {
        #   command = pkgs.writeShellScript "signature" ''
        #     cat ${config.sops.secrets.personal-email-signature.path}
        #   '';
        #   delimiter = "";
        #   showSignature = "append";
        # };
        userName = user.email.bob;
      };
      home.shellAliases.mail = "neomutt";
      programs = {
        lieer.enable = true;
        neomutt.macros = [
          {
            action = "<shell-escape>cd ~/Maildir/personal; gmi sync<enter>";
            key = "\Co";
            map = [ "index" ];
          }
        ];
        notmuch = {
          enable = true;
          new.tags = [ ];
        };
      };
      # sops.secrets = {
      #   work-email-password = {
      #     inherit mode sopsFile;
      #   };
      #   work-email-signature = {
      #     inherit mode sopsFile;
      #   };
      # };
    };
}
