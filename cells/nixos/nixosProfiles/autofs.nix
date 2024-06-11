{
  cell,
  config,
  inputs,
  options,
  pkgs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  l = nixpkgs.lib // mine.lib // builtins;
  ll = l.lists;
  # ls = l.strings;
  t = l.types;

  autoMaster = l.concatStringsSep "\n" (
    ll.flatten (l.mkAliasDefinitions options.vars.autofs.shares).content.contents
  );
in {
  options.vars.autofs = {
    shares = l.mkOpt (t.listOf t.str) [] "List of shares to add to the autoMaster list";
  };

  config = {
    environment.systemPackages = with pkgs; [
      curlftpfs
      fuse
    ];
    services = {
      autofs = {
        inherit autoMaster;
        enable = true;
      };
      gvfs = l.enabled;
    };
  };
}
