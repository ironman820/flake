{
  cell,
  config,
  inputs,
  pkgs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  c = config.vars.gpg;
  l = nixpkgs.lib // mine.lib // builtins;
  t = l.types;
in {
  options.vars.gpg = {
    enableSSHSupport = l.mkBoolOpt false "Enable SSH support for GPG";
    pinentryPackage = l.mkOpt (t.either t.pkgs t.str) "curses" "GPG Agent pin-entry flavor";
  };

  config = {
    programs.gnupg.agent = {
      inherit (c) enableSSHSupport;
      enable = true;
      pinentryPackage = pkgs."pinentry-${c.pinentryPackage}";
    };
  };
}
