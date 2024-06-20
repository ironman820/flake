{
  cell,
  inputs,
}: {
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
