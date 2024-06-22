{
  cell,
  inputs,
}: {
  ironman-laptop = {
    imports = [
      cell.nixosConfigurations.ironman-laptop
    ];
    deployment = {
      targetUser = "ironman";
    };
  };
  traefik-work = {
    deployment = {
      targetHost = "traefik.desk";
      targetUser = "ironman";
    };
    imports = [
      cell.nixosConfigurations.traefik-work
    ];
  };
}
