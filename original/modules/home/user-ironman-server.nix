{ self, ... }:
{
  flake.homeConfigurations.ironman-server = { osConfig, ... }: {
    imports = with self.homeModules; [
      base
    ];
    home.shellAliases = {
      ts = "tmux new-session -A -s ${osConfig.ironman.user.name} && exit";
    };
  };
}
