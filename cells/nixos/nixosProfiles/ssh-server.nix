{
  cell,
  inputs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  l = nixpkgs.lib // mine.lib // builtins;
  # p = mine.packages;
in {
  # programs.ssh.package = p.openssh;
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = l.mkDefault false;
      PermitRootLogin = l.mkDefault "no";
    };
  };
}
