{
  perSystem =
    {
      lib,
      self',
      pkgs,
      ...
    }:
    {
      apps.mytty = {
        meta.description = "Wrapper around screen to help connect to console devices";
        program = self'.packages.mytty;
      };
      packages.mytty = pkgs.writeShellScriptBin "mytty" ''
        if [ $# -eq 0 ]; then
             # No arguments provided, use defaults
             ${lib.getExe' pkgs.screen "screen"} /dev/ttyUSB0 9600
        elif [ $# -eq 1 ]; then
          if [ "$1" == "-h" || "$1" == "--help" ]; then
            echo "Example usage:"
            echo "mytty [device] [baudrate]"
            echo
            echo "If only one parameter is specified the script assumes it's the baud rate"
            echo "   and uses the default device: /dev/ttyUSB0"
            echo
            echo "Specifying no arguments runs the following default command:"
            echo "  screen /dev/ttyUSB0 9600"
            echo
            exit 0
          fi
             # One argument was provided, assume it's the baud rate and use default device
             ${lib.getExe' pkgs.screen "screen"} /dev/ttyUSB0 "$1"
        else
             # More than one argument was provided, use them
             ${lib.getExe' pkgs.screen "screen"} "$@"
        fi
      '';
    };
}
