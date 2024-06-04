{
  cell,
  inputs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  l = nixpkgs.lib // mine.lib // builtins;
in {
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = l.mkDefault false;
      PermitRootLogin = l.mkDefault "no";
    };
  };
}
