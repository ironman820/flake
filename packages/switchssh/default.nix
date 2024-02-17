{ pkgs, ... }:
let inherit (pkgs) writeScriptBin;
in writeScriptBin "switchssh" ''
  #!${pkgs.expect}/bin/expect
  eval spawn -noecho ssh $argv
  interact {
    \177 { send "\010" }
    "\033\[3~" { send "\177" }
  }
''
