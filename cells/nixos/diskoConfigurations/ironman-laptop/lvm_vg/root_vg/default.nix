{
  type = "lvm_vg";
  lvs.root = {
    size = "100%FREE";
    content = {
      type = "btrfs";
      extraArgs = ["-f"];
      subvolumes = let
        mountOpts = ["compress=zstd"];
      in {
        "/root" = {
          mountpoint = "/";
          mountOptions = mountOpts ++ ["subvol=root"];
        };
        "/nix" = {
          mountpoint = "/nix";
          mountOptions = mountOpts ++ ["subvol=nix" "noatime"];
        };
      };
      mountpoint = "/partition-root";
    };
  };
}
