{
  device = "/dev/sda";
  type = "disk";
  content = {
    type = "gpt";
    partitions = {
      home = {
        size = "100%";
        content = {
          type = "lvm_pv";
          vg = "home_vg";
        };
      };
    };
  };
}
