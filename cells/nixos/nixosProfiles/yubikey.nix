{
  cell,
  inputs,
  pkgs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  l = nixpkgs.lib // mine.lib // builtins;
in {
  vars.gpg = {
    enableSSHSupport = true;
  };
  environment = {
    shellInit = ''
      gpg-connect-agent /bye
      export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    '';
    systemPackages = with pkgs; [
      gnupg
      yubikey-personalization
    ];
  };
  hardware.gpgSmartcards = l.enabled;
  programs.ssh = {
    enableAskPassword = true;
    startAgent = false;
  };
  security.pam.u2f = {
    enable = true;
    cue = true;
    origin = "pam://ironman";
  };
  services = {
    pcscd.enable = true;
    udev.packages = with pkgs; [
      yubikey-personalization
    ];
    yubikey-agent = l.enabled;
  };
}
