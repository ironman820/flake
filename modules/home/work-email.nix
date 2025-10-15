{
  flake.homeModules.work-email =
    {
      config,
      flakeRoot,
      lib,
      osConfig,
      pkgs,
      ...
    }:
    let
      inherit (osConfig.ironman) user;
      mode = "0400";
      sopsFile = flakeRoot + "/.secrets/email.yaml";
    in
    {
      accounts.email.accounts.work = {
        enable = true;
        address = lib.strings.concatStringsSep "@" [
          user.email.bob
          user.email.site
        ];
        folders = {
          drafts = "Inbox/.Drafts";
          trash = "Inbox/.Trash";
        };
        imap = {
          authentication = "plain";
          host = "mail.royell.org";
          tls.enable = true;
        };
        imapnotify = {
          enable = false;
          boxes = [ "Inbox" ];
        };
        mbsync = {
          enable = true;
          create = "maildir";
          expunge = "both";
          extraConfig.account = {
            "AuthMechs" = "LOGIN";
          };
          remove = "both";
          subFolders = "Maildir++";
        };
        msmtp.enable = true;
        neomutt = {
          enable = true;
          extraMailboxes = [
            {
              mailbox = "Inbox/.Archive";
              name = "Archive";
            }
            {
              mailbox = "Inbox/.[Gmail]";
              name = "[Gmail]";
            }
            {
              mailbox = "Inbox/.[Gmail].Drafts";
              name = "[Gmail].Drafts";
            }
            {
              mailbox = "Inbox/.Archive";
              name = "Archive";
            }
            {
              mailbox = "Inbox/.Archives";
              name = "Archives";
            }
            {
              mailbox = "Inbox/.Archives.2020";
              name = "Archives.2020";
            }
            {
              mailbox = "Inbox/.Archives.2021";
              name = "Archives.2021";
            }
            {
              mailbox = "Inbox/.Archives.2022";
              name = "Archives.2022";
            }
            {
              mailbox = "Inbox/.Archives.2023";
              name = "Archives.2023";
            }
            {
              mailbox = "Inbox/.Archives.2024";
              name = "Archives.2024";
            }
            {
              mailbox = "Inbox/.Archives.2025";
              name = "Archives.2025";
            }
            {
              mailbox = "Inbox/.Drafts";
              name = "Drafts";
            }
            {
              mailbox = "Inbox/.Save";
              name = "Save";
            }
            {
              mailbox = "Inbox/.Sent";
              name = "Sent";
            }
            {
              mailbox = "Inbox/.Spambox";
              name = "Spambox";
            }
            {
              mailbox = "Inbox/.techissues";
              name = "techissues";
            }
            {
              mailbox = "Inbox/.Trash";
              name = "Trash";
            }
            {
              mailbox = "Inbox/.Unwanted";
              name = "Unwanted";
            }
          ];
          mailboxName = "Inbox";
        };
        passwordCommand = "cat ${config.sops.secrets.work-email-password.path}";
        primary = lib.mkDefault false;
        realName = user.fullName;
        signature = {
          command = pkgs.writeShellScript "signature" ''
            cat ${config.sops.secrets.work-email-signature.path}
          '';
          delimiter = "";
          showSignature = "append";
        };
        smtp = {
          authentication = "digest_md5";
          host = "mail.royell.org";
          tls.enable = true;
        };
        userName = user.email.bob;
      };
      home.shellAliases.mail = "neomutt";
      programs = {
        mbsync.enable = true;
        msmtp.enable = true;
        neomutt.macros = [
          {
            action = "<shell-escape>mbsync --all<enter>";
            key = "\\Co";
            map = [ "index" ];
          }
          {
            action = ";<save-message>=Inbox/.Archive<enter>";
            key = "Ma";
            map = [
              "index"
              "pager"
            ];
          }
          {
            action = ";<save-message>=Inbox/.Trash<enter>";
            key = "Mt";
            map = [
              "index"
              "pager"
            ];
          }
        ];
      };
      services.mbsync.enable = true;
      sops.secrets = {
        work-email-password = {
          inherit mode sopsFile;
        };
        work-email-signature = {
          inherit mode sopsFile;
        };
      };
    };
}
