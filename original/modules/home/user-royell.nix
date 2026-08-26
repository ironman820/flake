{ self, ... }:
{
  flake.homeConfigurations.royell =
    {
      imports = with self.homeModules; [
        base
      ];
    };
}
