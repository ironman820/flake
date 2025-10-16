{
  flake.homeModules.neomutt = _: {
    programs = {
      neomutt = {
        enable = true;
        binds = [
          {
            action = "noop";
            key = "i";
            map = [
              "index"
              "pager"
            ];
          }
          {
            action = "noop";
            key = "\\Cf";
            map = [ "index" ];
          }
          {
            action = "noop";
            key = "M";
            map = [
              "index"
              "pager"
            ];
          }
          {
            action = "noop";
            key = "C";
            map = [
              "index"
              "pager"
            ];
          }
          {
            action = "display-message";
            key = "l";
            map = [ "index" ];
          }
        ];
        changeFolderWhenSourcingAccount = true;
        macros = [
          {
            action = ";<save-message>Archive<enter>";
            key = "Ma";
            map = [
              "index"
              "pager"
            ];
          }
          {
            action = "<change-folder>Archive<enter>";
            key = "ga";
            map = [
              "index"
              "pager"
            ];
          }
          {
            action = "<change-folder>Inbox<enter>";
            key = "gi";
            map = [
              "index"
              "pager"
            ];
          }
          {
            action = ";<save-message>Inbox<enter>";
            key = "Mi";
            map = [
              "index"
              "pager"
            ];
          }
          {
            action = ";<save-message>Trash<enter>";
            key = "Mt";
            map = [
              "index"
              "pager"
            ];
          }
          {
            action = "<change-folder>Trash<enter>";
            key = "gt";
            map = [
              "index"
              "pager"
            ];
          }
        ];
        vimKeys = true;
      };
    };
  };
}
