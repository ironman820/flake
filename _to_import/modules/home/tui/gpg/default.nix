{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.mine) mkBoolOpt;
  inherit (pkgs) writeShellScript;

  cfg = config.mine.home.tui.gpg;
  scriptsDir = "scripts/personal-gpg";
in {
  options.mine.home.tui.gpg = {
    enable = mkBoolOpt true "Enable the module";
  };
  config = mkIf cfg.enable {
    mine.home = {
      sops.secrets = {
        "pass-key" = {
          mode = "0400";
          path = "${scriptsDir}/passkey.asc";
          sopsFile = ./secrets/gpg.yaml;
        };
      };
    };
    home.file = {
      "${scriptsDir}/changekey.sh".source = writeShellScript "changekey.sh" ''
        echo "Insert the new key to authenticate."
        read -sp "Press 'Enter' to continue."
        gpg-connect-agent "scd serialno" "learn --force" /bye
        echo "Finished"
      '';
      "${scriptsDir}/install.sh".source = writeShellScript "install.sh" ''
        if !(gpg -K --keyid-format LONG | grep -iq A963288EA443E871) ; then
          gpg --import passkey.asc
        fi

        if !(gpg -K --keyid-format LONG | grep -iq 9F30DA1A16D74EA7) ; then
          gpg --receive-keys 185B6FE0AC2034D0EB2F0ADD11B0F08E0A4D904B 2>&1 > /dev/null
          echo -e "5\ny\n" | gpg --command-fd 0 --expert --edit-key 11B0F08E0A4D904B trust;
          echo "If you don't have your GPG Card, the next phase will error out."
          echo "If that happens, run gpg --card-status once your have your card connected."
          read -sp "Please insert your GPG Card and press a key to continue..."
          gpg --card-status 2>&1 > /dev/null

          echo "Finished!"
        fi
      '';
      "${scriptsDir}/passinit.sh".source = writeShellScript "passinit.sh" ''
        pass init 0xA963288EA443E871
      '';
    };
  };
}
