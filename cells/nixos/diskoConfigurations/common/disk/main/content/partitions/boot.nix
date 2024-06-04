{
  name = "boot";
  size = "512M";
  type = "EF00";
  content = {
    type = "filesystem";
    format = "vfat";
    mountpoint = "/boot";
  };
}
