{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkMerge;
  inherit (lib.mine) enabled mkBoolOpt;
  inherit (pkgs) writeShellScript;

  cfg = config.mine.home.tui.neomutt;
  configFolder = "${config.xdg.configHome}/mutt";
  imp = config.mine.home.impermanence.enable;
  os = osConfig.mine.tui.neomutt;
in {
  options.mine.home.tui.neomutt = {
    enable = mkBoolOpt os.enable "Install Neomutt";
    notmuchPersonal = mkBoolOpt cfg.personalEmail "Whether to setup notmuch for personal email";
    notmuchWork = mkBoolOpt (!cfg.notmuchPersonal) "Whether to setup notmuch for work email";
    personalEmail = mkEnableOption "Setup Personal Email";
    workEmail = mkEnableOption "Setup Work Email";
  };

  config = mkIf cfg.enable (let
    sopsFile = ./secrets/neomutt.yaml;
  in {
    mine.home = {
      tui = {
        imapfilter = {
          enable = true;
          home = cfg.personalEmail;
          work = cfg.workEmail;
        };
        just.apps = [
          "~/scripts/just/emailpass.sh"
        ];
      };
      pass = enabled;
      sops.secrets = mkMerge [
        {
          "mbsync" = {
            inherit sopsFile;
            path = "${config.home.homeDirectory}/.mbsyncrc";
          };
          "msmtp_config" = {
            inherit sopsFile;
            path = "${config.xdg.configHome}/msmtp/config";
          };
          "work_sig" = {
            inherit sopsFile;
            path = "${configFolder}/signatures/work.sig";
          };
          "personal_sig" = {
            inherit sopsFile;
            path = "${configFolder}/signatures/personal.sig";
          };
          "email-pass" = {
            format = "binary";
            mode = "0400";
            path = "${config.home.homeDirectory}/scripts/just/email-pass.7z";
            sopsFile = ./secrets/email-pass;
          };
        }
        (mkIf cfg.personalEmail {
          "muttrc_personal_email" = {
            inherit sopsFile;
            path = "${configFolder}/accounts/master.muttrc";
          };
          "muttrc_work_email" = {
            inherit sopsFile;
            path = "${configFolder}/accounts/work.muttrc";
          };
          "notmuch-personal-config" = mkIf cfg.notmuchPersonal {
            inherit sopsFile;
            path = "${config.home.homeDirectory}/.notmuch-config";
          };
        })
        (mkIf cfg.workEmail {
          "muttrc_work_email" = {
            inherit sopsFile;
            path = "${configFolder}/accounts/master.muttrc";
          };
          "muttrc_personal_email" = {
            inherit sopsFile;
            path = "${configFolder}/accounts/personal.muttrc";
          };
          "notmuch-work-config" = mkIf cfg.notmuchWork {
            inherit sopsFile;
            path = "${config.home.homeDirectory}/.notmuch-config";
          };
        })
      ];
    };
    home = {
      file."scripts/just/emailpass.sh".source = writeShellScript "emailpass.sh" ''
        7z x -o/home/${config.mine.home.user.name}/.local/share/password-store/ email-pass.7z
      '';
      persistence."/persist/home".directories = mkIf imp [
        ".cache/mutt-wizard"
        ".local/share/mail"
        ".local/share/password-store"
      ];
      shellAliases.mail = "neomutt";
    };
    programs.neomutt = enabled;
    systemd.user = {
      services."imapcheck" = {
        Unit.Description = "Run mutt-wizard to check all email accounts.";
        Install.WantedBy = ["default.target"];
        Service = {
          ExecStart = [
            "${pkgs.imapfilter}/bin/imapfilter -c \"${config.xdg.configHome}/imapfilter/config.lua\""
            "${pkgs.isync}/bin/mbsync -a"
          ];
          Type = "oneshot";
        };
      };
      timers."imapcheck" = {
        Install.WantedBy = ["timers.target"];
        Timer = {
          OnStartupSec = "150";
          OnCalendar = "*:0/5";
        };
      };
    };
    xdg.configFile = let
      inherit (config.mine.home.user.settings.applications) browser;
    in {
      "mutt/mailcap".text = ''
        text/calendar; ${pkgs.khal}/bin/khal import %s ;
        text/csv; ${pkgs.libreoffice-fresh}/lib/libreoffice/program/soffice %s ;
        text/plain; $EDITOR %s ;
        text/html; ${pkgs.${browser}}/bin/${browser} %s &; nametemplate=%s.html
        text/html; w3m -I %{charset} -T text/html -dump %s; copiousoutput;
        text/html; ${pkgs.mutt-wizard}/lib/mutt-wizard/openfile %s ; nametemplate=%s.html
        image/*; fim %s &;
        image/*; ${pkgs.mutt-wizard}/lib/mutt-wizard/openfile %s ;
        video/*; setsid mpv --quiet %s &; copiousoutput
        audio/*; vlc %s &;
        application/pdf; zathura %s &;
        application/pdf; ${pkgs.mutt-wizard}/lib/mutt-wizard/openfile %s ;
        application/pgp-encrypted; gpg -d '%s'; copiousoutput;
        application/pgp-keys; gpg --import '%s'; copiousoutput;
        application/vnd.openxmlformats-officedocument.spreadsheetml.sheet; ${pkgs.libreoffice-fresh}/lib/libreoffice/program/soffice %s ;
      '';
      "mutt/muttrc".text = ''
        # vim: filetype=neomuttrc
        source ${configFolder}/theme
        # This file contains all of mutt-wizard's default settings.
        # mutt-wizard will have this file sourced from your muttrc.
        # In the interest of seamless updating, do not edit this file.
        # If you want to override any settings, set those in your muttrc.
        set mailcap_path = ${configFolder}/mailcap:$mailcap_path
        set mime_type_query_command = "file --mime-type -b %s"
        set date_format="%y/%m/%d %I:%M%p"
        set index_format="%2C %Z %?X?A& ? %D %-15.15F %s (%-4.4c)"
        set use_threads = 'threads' sort = 'reverse-last-date'
        set smtp_authenticators = 'gssapi:login'
        set query_command = "${pkgs.abook}/bin/abook --mutt-query '%s'"
        set rfc2047_parameters = yes
        set sleep_time = 0		# Pause 0 seconds for informational messages
        set markers = no		# Disables the `+` displayed at line wraps
        set mark_old = no		# Unread mail stay unread until read
        set mime_forward = yes		# attachments are forwarded with mail
        set wait_key = no		# mutt won't ask "press key to continue"
        set fast_reply			# skip to compose when replying
        set fcc_attach			# save attachments with the body
        set forward_format = "Fwd: %s"	# format of subject when forwarding
        set forward_quote		# include message in forwards
        set reverse_name		# reply as whomever it was to
        set include			# include message in replies
        set mail_check=60 # to avoid lags using IMAP with some email providers (yahoo for example)
        set editor = "nvim +':set textwidth=0'"
        auto_view text/html		# automatically show html (mailcap uses lynx)
        auto_view application/pgp-encrypted
        #set display_filter = "tac | sed '/\\\[-- Autoview/,+1d' | tac" # Suppress autoview messages.
        alternative_order text/plain text/enriched text/html

        bind index,pager i noop
        bind index,pager g noop
        bind index \Cf noop
        bind index,pager M noop
        bind index,pager C noop

        # General rebindings
        bind index gg first-entry
        bind index j next-entry
        bind index k previous-entry
        bind attach <return> view-mailcap
        bind attach l view-mailcap
        bind editor <space> noop
        bind index G last-entry
        bind index gg first-entry
        bind pager,attach h exit
        bind pager j next-line
        bind pager k previous-line
        bind pager l view-attachments
        bind index D delete-message
        bind index U undelete-message
        bind index L limit
        bind index h noop
        bind index l display-message
        bind index,query <space> tag-entry
        #bind browser h goto-parent
        macro browser h '<change-dir><kill-line>..<enter>' "Go to parent folder"
        bind index,pager H view-raw-message
        bind browser l select-entry
        bind pager,browser gg top-page
        bind pager,browser G bottom-page
        bind index,pager,browser d half-down
        bind index,pager,browser u half-up
        bind index,pager S sync-mailbox
        bind index,pager R group-reply
        bind index \031 previous-undeleted	# Mouse wheel
        bind index \005 next-undeleted		# Mouse wheel
        bind pager \031 previous-line		# Mouse wheel
        bind pager \005 next-line		# Mouse wheel
        bind editor <Tab> complete-query

        macro index,pager Ci ";<copy-message>=INBOX<enter>" "copy mail to inbox"
        macro index,pager gd "<change-folder>=Drafts<enter>" "go to drafts"
        macro index,pager Md ";<save-message>=Drafts<enter>" "move mail to drafts"
        macro index,pager Cd ";<copy-message>=Drafts<enter>" "copy mail to drafts"
        macro index,pager gj "<change-folder>=Junk<enter>" "go to junk"
        macro index,pager Mj ";<save-message>=Junk<enter>" "move mail to junk"
        macro index,pager Cj ";<copy-message>=Junk<enter>" "copy mail to junk"
        macro index,pager Ct ";<copy-message>=Trash<enter>" "copy mail to trash"
        macro index,pager gs "<change-folder>=Sent<enter>" "go to sent"
        macro index,pager Ms ";<save-message>=Sent<enter>" "move mail to sent"
        macro index,pager Cs ";<copy-message>=Sent<enter>" "copy mail to sent"
        macro index,pager Ca ";<copy-message>=Archive<enter>" "copy mail to archive"
        macro index,pager Mv ";<save-message>" "Move mail to a manualy entered folder"
        macro index,pager Cp ";<copy-message>" "Copy mail to a manually entered folder"

        #set crypt_autosign = yes
        #set crypt_opportunistic_encrypt = yes
        #set pgp_self_encrypt = yes
        #set pgp_default_key  = 'your@gpgemailaddre.ss'

        macro index,pager a "<enter-command>set my_pipe_decode=\$pipe_decode pipe_decode<return><pipe-message>abook --add-email<return><enter-command>set pipe_decode=\$my_pipe_decode; unset my_pipe_decode<return>" "add the sender address to abook"
        macro index \Cr "T~U<enter><tag-prefix><clear-flag>N<untag-pattern>.<enter>" "mark all messages as read"
        macro index O "<shell-escape>mw -Y<enter>" "run mw -Y to sync all mail"
        macro index \Cf "<enter-command>unset wait_key<enter><shell-escape>printf 'Enter a search term to find with notmuch: '; read x; echo \$x >~/.cache/mutt_terms<enter><limit>~i \"\`notmuch search --output=messages \$(cat ~/.cache/mutt_terms) | head -n 600 | perl -le '@a=<>;s/\^id:// for@a;$,=\"|\";print@a' | perl -le '@a=<>; chomp@a; s/\\+/\\\\+/ for@a;print@a' \`\"<enter>" "show only messages matching a notmuch pattern"
        macro index A "<limit>all\n" "show all messages (undo limit)"

        # Sidebar mappings
        set sidebar_visible = no
        set sidebar_width = 20
        set sidebar_short_path = yes
        set sidebar_next_new_wrap = yes
        set mail_check_stats
        set sidebar_format = '%D%?F? [%F]?%* %?N?%N/? %?S?%S?'
        bind index,pager \Ck sidebar-prev
        bind index,pager \Cj sidebar-next
        bind index,pager \Co sidebar-open
        bind index,pager \Cp sidebar-prev-new
        bind index,pager \Cn sidebar-next-new
        bind index,pager B sidebar-toggle-visible

        # Default index colors:
        color index yellow default '.*'
        color index_author red default '.*'
        color index_number blue default
        color index_subject cyan default '.*'

        # New mail is boldened:
        color index brightyellow black "~N"
        color index_author brightred black "~N"
        color index_subject brightcyan black "~N"

        # Tagged mail is highlighted:
        color index brightyellow blue "~T"
        color index_author brightred blue "~T"
        color index_subject brightcyan blue "~T"

        # Other colors and aesthetic settings:
        mono bold bold
        mono underline underline
        mono indicator reverse
        mono error bold
        color normal default default
        color indicator brightblack white
        color sidebar_highlight red default
        color sidebar_divider brightblack black
        color sidebar_flagged red black
        color sidebar_new green black
        color normal brightyellow default
        color error red default
        color tilde black default
        color message cyan default
        color markers red white
        color attachment white default
        color search brightmagenta default
        color status brightyellow black
        color hdrdefault brightgreen default
        color quoted green default
        color quoted1 blue default
        color quoted2 cyan default
        color quoted3 yellow default
        color quoted4 red default
        color quoted5 brightred default
        color signature brightgreen default
        color bold black default
        color underline black default
        color normal default default

        # Regex highlighting:
        color header brightmagenta default "^From"
        color header brightcyan default "^Subject"
        color header brightwhite default "^(CC|BCC)"
        color header blue default ".*"
        color body brightred default "[\-\.+_a-zA-Z0-9]+@[\-\.a-zA-Z0-9]+" # Email addresses
        color body brightblue default "(https?|ftp)://[\-\.,/%~_:?&=\#a-zA-Z0-9]+" # URL
        color body green default "\`[^\`]*\`" # Green text between ` and `
        color body brightblue default "^# \.*" # Headings as bold blue
        color body brightcyan default "^## \.*" # Subheadings as bold cyan
        color body brightgreen default "^### \.*" # Subsubheadings as bold green
        color body yellow default "^(\t| )*(-|\\*) \.*" # List items as yellow
        color body brightcyan default "[;:][-o][)/(|]" # emoticons
        color body brightcyan default "[;:][)(|]" # emoticons
        color body brightcyan default "[ ][*][^*]*[*][ ]?" # more emoticon?
        color body brightcyan default "[ ]?[*][^*]*[*][ ]" # more emoticon?
        color body red default "(BAD signature)"
        color body cyan default "(Good signature)"
        color body brightblack default "^gpg: Good signature .*"
        color body brightyellow default "^gpg: "
        color body brightyellow red "^gpg: BAD signature from.*"
        mono body bold "^gpg: Good signature"
        mono body bold "^gpg: BAD signature from.*"
        color body red default "([a-z][a-z0-9+-]*://(((([a-z0-9_.!~*'();:&=+$,-]|%[0-9a-f][0-9a-f])*@)?((([a-z0-9]([a-z0-9-]*[a-z0-9])?)\\.)*([a-z]([a-z0-9-]*[a-z0-9])?)\\.?|[0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+)(:[0-9]+)?)|([a-z0-9_.!~*'()$,;:@&=+-]|%[0-9a-f][0-9a-f])+)(/([a-z0-9_.!~*'():@&=+$,-]|%[0-9a-f][0-9a-f])*(;([a-z0-9_.!~*'():@&=+$,-]|%[0-9a-f][0-9a-f])*)*(/([a-z0-9_.!~*'():@&=+$,-]|%[0-9a-f][0-9a-f])*(;([a-z0-9_.!~*'():@&=+$,-]|%[0-9a-f][0-9a-f])*)*)*)?(\\?([a-z0-9_.!~*'();/?:@&=+$,-]|%[0-9a-f][0-9a-f])*)?(#([a-z0-9_.!~*'();/?:@&=+$,-]|%[0-9a-f][0-9a-f])*)?|(www|ftp)\\.(([a-z0-9]([a-z0-9-]*[a-z0-9])?)\\.)*([a-z]([a-z0-9-]*[a-z0-9])?)\\.?(:[0-9]+)?(/([-a-z0-9_.!~*'():@&=+$,]|%[0-9a-f][0-9a-f])*(;([-a-z0-9_.!~*'():@&=+$,]|%[0-9a-f][0-9a-f])*)*(/([-a-z0-9_.!~*'():@&=+$,]|%[0-9a-f][0-9a-f])*(;([-a-z0-9_.!~*'():@&=+$,]|%[0-9a-f][0-9a-f])*)*)*)?(\\?([-a-z0-9_.!~*'();/?:@&=+$,]|%[0-9a-f][0-9a-f])*)?(#([-a-z0-9_.!~*'();/?:@&=+$,]|%[0-9a-f][0-9a-f])*)?)[^].,:;!)? \t\r\n<>\"]"
        source $HOME/.config/mutt/accounts/master.muttrc
      '';
      "mutt/personal.mailboxes".text = ''
        mailboxes "=INBOX" "=Mailing lists" "=Personal/Devotions" "=Personal/Receipts" "=Read Later" "=[Gmail]/All Mail" "=[Gmail]/Chats" "=[Gmail]/Drafts" "=[Gmail]/Important" "=[Gmail]/Sent Mail" "=[Gmail]/Spam" "=[Gmail]/Starred" "=[Gmail]/Trash"
      '';
      "mutt/switch.muttrc".text = ''
        # vim: filetype=neomuttrc
        # This is an embarrassing and hacky file that unbinds a bunch of binds between
        # switching accounts. It is called each time an account is changed.
        unset hostname
        unmy_hdr Organization
        unmailboxes *
        unalternates *
        unset signature
      '';
      "mutt/theme".source = "${pkgs.catppuccin-neomutt}/catppuccin-neomutt";
      "mutt/work.mailboxes".text = ''
        mailboxes "=Archive" "=Archives" "=Archives/2020" "=Archives/2021" "=Archives/2022" "=Archives/2023" "=Drafts" "=INBOX" "=Junk E-mail" "=Sent" "=Spambox" "=Trash" "=Unwanted"
      '';
    };
  });
}
