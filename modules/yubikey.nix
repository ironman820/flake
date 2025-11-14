{
  flake.nixosModules.yubikey =
    {
      pkgs,
      ...
    }:
    {
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
      hardware.gpgSmartcards.enable = true;
      programs = {
        gnupg.agent = {
          enable = true;
          enableSSHSupport = true;
        };
        ssh = {
          enableAskPassword = true;
          startAgent = false;
        };
      };
      security.pam.u2f = {
        enable = true;
        settings = {
          cue = true;
          origin = "pam://ironman";
        };
      };
      services = {
        pcscd.enable = true;
        udev.packages = with pkgs; [
          yubikey-personalization
        ];
        yubikey-agent.enable = true;
      };
    };
}
