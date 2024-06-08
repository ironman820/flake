{
  cell,
  config,
  inputs,
}: {
  sops.secrets.authorized_keys = {
    sopsFile = ./__secrets/keys.yaml;
    path = "${config.home.homeDirectory}/.ssh/authorized_keys";
  };
}
