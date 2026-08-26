{
  moduleWithSystem,
  ...
}:
{
  flake.homeModules.tealdeer = moduleWithSystem (
    perSystem@{ self', ... }: { lib, ... }: {
    home.shellAliases.man = "${lib.getExe self'.packages.manman}";
    programs.tealdeer = {
      enable = true;
      enableAutoUpdates = true;
      settings = {
        use_pager = true;
      };
    };
  });
  perSystem =
    {
      self',
      lib,
      pkgs,
      ...
    }:
    {
      apps.manman = {
        meta.description = "";
        program = self'.packages.manman;
      };
      packages.manman = pkgs.writers.writePython3Bin "manman" {
        doCheck = false;
      } ''
        import argparse
        import os
        import subprocess


        def main() -> None:
            parser = argparse.ArgumentParser(
                'manman',
                usage="%(prog)s [options] program",
                description='Ironman820\'s man wrapper',
                epilog="Checks tldr and responds with man if it's not found"
            )
            parser.add_argument(
              '-f',
              '--full',
              action='store_true',
              help="Skip TLDR and open man directly",
            )
            parser.add_argument(
              'program',
              help="Name of application to find",
              nargs=1,
            )
            args = parser.parse_args()

            program = args.program[0]

            if (args.full):
                os.system(
                  f'${lib.getExe pkgs.man} {program}',
                )
                exit(0)

            commands = subprocess.run(
              [
                '${lib.getExe pkgs.tealdeer}',
                '--quiet',
                '--list',
              ],
              capture_output=True,
              encoding='utf-8',
            ).stdout.splitlines()

            if (program in commands):
                os.system(
                  f'${lib.getExe pkgs.tealdeer} {program}',
                )
                exit(0)
            os.system(
              f'${lib.getExe pkgs.man} {program}',
            )


        if __name__ == "__main__":
            main()
      '';
    };
}
