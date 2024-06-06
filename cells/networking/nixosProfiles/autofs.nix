{
  cell,
  config,
  inputs,
  lib,
  options,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  l = nixpkgs.lib // mine.lib // builtins;
  ll = l.lists;
  # ls = l.strings;
  lt = l.types;

  autoMaster = l.concatStringsSep "\n" (
    ll.flatten (l.mkAliasDefinitions options.mine.networking.autofs.shares).content.contents
  );
in {
  options.mine.networking.autofs = {
    shares = l.mkOpt (lt.listOf lt.str) [] "List of shares to add to the autoMaster list";
  };

  config = {
    environment.systemPackages = with nixpkgs; [
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
