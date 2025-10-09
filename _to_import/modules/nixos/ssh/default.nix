{
    lib,
    config,
    ...
}: let
  inherit (config.mine.user) name;
  inherit (lib) mkIf;
  inherit (lib.mine) enabled mkBoolOpt;

  cfg = config.mine.ssh;
in {
  options.mine.ssh = {
    enable = mkBoolOpt true "Enable the module";
  };
  config = mkIf cfg.enable {
    services.openssh = enabled;
    users.users = {
      root.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL3Ue/VoEgGG4nzoW3jpiwlnmWApkUyu/j1VmEwiSdy7"
      ];
      ${name}.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL3Ue/VoEgGG4nzoW3jpiwlnmWApkUyu/j1VmEwiSdy7"
      ];
    };
  };
}
