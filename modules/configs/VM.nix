{
  flake.nixosModules.VM = { modulesPath, pkgs, ... }: {
    imports = [
      (modulesPath + "/profiles/qemu-guest.nix")
    ];
    ironman = {
      grub = false;
      server.lxc = false;
    };
    boot.kernelParams = [
      "console=ttyS0,115200"
    ];

    # Disable the upstream getty module's automatic configuration for serial-getty@
    # This prevents conflicts with our custom configuration
    systemd.services = {
      "serial-getty@".enable = false;
      "serial-getty@ttyS0" = {
        enable = true;
        wantedBy = [ "getty.target" ];
        after = [ "systemd-user-sessions.service" ];
        wants = [ "systemd-user-sessions.service" ];
        serviceConfig = {
          Type = "idle";
          Restart = "always";
          Environment = "TERM=vt220";
          ExecStart = "${pkgs.util-linux}/bin/agetty --login-program ${pkgs.shadow}/bin/login --noclear --keep-baud ttyS0 115200,57600,38400,9600 vt220";
          UtmpIdentifier = "ttyS0";
          StandardInput = "tty";
          StandardOutput = "tty";
          TTYPath = "/dev/ttyS0";
          TTYReset = "yes";
          TTYVHangup = "yes";
          IgnoreSIGPIPE = "no";
          SendSIGHUP = "yes";
        };
      };
    };
  };
}
