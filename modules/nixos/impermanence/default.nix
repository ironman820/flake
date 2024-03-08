{
  lib,
  options,
  config,
  ...
}: let
  inherit (lib) mkAliasDefinitions mkEnableOption mkIf;
  inherit (lib.mine) mkOpt;
  inherit (lib.types) attrs either listOf str;

  cfg = config.mine.impermanence;
in {
  options.mine.impermanence = {
    enable = mkEnableOption "Enable the module";
    directories = mkOpt (listOf (either attrs str)) [] "List of directories to save for root";
    files = mkOpt (listOf (either attrs str)) [] "list of files to save for root";
  };

  config = mkIf cfg.enable {
    boot.initrd.postDeviceCommands = lib.mkAfter ''
      mkdir /btrfs_tmp
      mount /dev/disk/by-partlabel/nixroot /btrfs_tmp
      if [[ -e /btrfs_tmp/root ]]; then
          mkdir -p /btrfs_tmp/old_roots
          timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
          mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
      fi

      delete_subvolume_recursively() {
          IFS=$'\n'
          for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
              delete_subvolume_recursively "/btrfs_tmp/$i"
          done
          btrfs subvolume delete "$1"
      }

      for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
          delete_subvolume_recursively "$i"
      done

      btrfs subvolume create /btrfs_tmp/root
      umount /btrfs_tmp
    '';
    environment.persistence."/persist/root" = {
      hideMounts = true;
      directories = mkAliasDefinitions options.mine.impermanence.directories;
      files = mkAliasDefinitions options.mine.impermanence.files;
    };
    fileSystems."/persist".neededForBoot = true;
  };
}
