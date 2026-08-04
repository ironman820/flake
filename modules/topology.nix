{
  self,
  ...
}:
{
  perSystem =
    { ... }:
    {
      topology.modules = [
        {
          networks.home = {
            name = "Home Network";
            cidrv4 = "192.168.248.1/23";
          };
        }
        { nixosConfigurations = self.nixosConfigurations; }
      ];
    };
}
