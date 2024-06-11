{
  cell,
  inputs,
}: let
  inherit (inputs.nixpkgs) writeShellScript;
  scriptsDir = "scripts/personal-gpg";
in {
  sops.secrets = {
    "pass-key" = {
      mode = "0400";
      path = "${scriptsDir}/passkey.asc";
      sopsFile = ./__secrets/gpg.yaml;
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
  programs.gpg = {
    enable = true;
    settings = {
      personal-cipher-preferences = "AES256 AES192 AES";
      personal-digest-preferences = "SHA512 SHA384 SHA256";
      personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";
      default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
      cert-digest-algo = "SHA512";
      s2k-digest-algo = "SHA512";
      s2k-cipher-algo = "AES256";
      charset = "utf-8";
      fixed-list-mode = true;
      no-comments = true;
      no-emit-version = true;
      no-greeting = true;
      keyid-format = "0xlong";
      list-options = "show-uid-validity";
      verify-options = "show-uid-validity";
      with-fingerprint = true;
      require-cross-certification = true;
      no-symkey-cache = true;
      use-agent = true;
      throw-keyids = true;
    };
  };
  services.gpg-agent = {
    enable = true;
    enableScDaemon = true;
    enableSshSupport = true;
    extraConfig = ''
      ttyname $GPG_TTY
    '';
    defaultCacheTtl = 10800;
    maxCacheTtl = 21600;
  };
}
