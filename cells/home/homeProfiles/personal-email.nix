{
  cell,
  config,
  inputs,
}: let
  # inherit (inputs) nixpkgs;
  # inherit (inputs.cells) mine;
  # l = nixpkgs.lib // mine.lib // builtins;
  configFolder = "${config.xdg.configHome}/mutt";
  sopsFile = v.emailSops;
  v = config.vars;
in {
  sops.secrets = {
    "muttrc_personal_email" = {
      inherit sopsFile;
      path = "${configFolder}/accounts/master.muttrc";
    };
    "muttrc_work_email" = {
      inherit sopsFile;
      path = "${configFolder}/accounts/work.muttrc";
    };
    "notmuch-personal-config" = {
      inherit sopsFile;
      path = "${config.home.homeDirectory}/.notmuch-config";
    };
  };
}
