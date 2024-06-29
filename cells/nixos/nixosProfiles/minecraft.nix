{
  cell,
  inputs,
}: {
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      minecraft = {
        environment = {
          ALLOW_CHEATS = "true";
          EULA = "TRUE";
          DIFFICULTY = "2";
          OPS = "2535416893293314";
          SERVER_NAME = "SmartyKat9 and Friends";
          TZ = "America/Chicago";
          VERSION = "LATEST";
          TEXTUREPACK_REQUIRED = "true";
        };
        image = "itzg/minecraft-bedrock-server";
        ports = ["0.0.0.0:19132:19132/udp"];
        volumes = ["/home/ironman/srv/minecraft/:/data"];
      };
    };
  };
}
