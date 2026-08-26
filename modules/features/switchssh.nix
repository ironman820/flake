{
  perSystem =
    {
      lib,
      pkgs,
      self',
      ...
    }:
    {
      apps.switchssh = {
        meta.description = "SSH wrapper that replaces backspace with older ^H keystroke.";
        program = self'.packages.switchssh;
      };
      packages.switchssh = pkgs.writeScriptBin "switchssh" ''
        #!${lib.getExe pkgs.expect}
        eval spawn -noecho ssh $argv
        interact {
          \177 { send "\010" }
          "\033\[3~" { send "\177" }
        }
      '';
    };
}
