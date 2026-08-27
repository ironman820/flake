{
  inputs,
  pkgs,
  self,
  ...
}:
{
  imports = [
  ]
  ++ (with self.nixosModules; [
    extraGuiApps
    arduino
    grub
    fonts
    drive-shares
    laptop
    virtualHost
    docker
    winbox
    x64-linux
  ]);
  environment.systemPackages = with pkgs; [
    calibre
    distrobox
    docker-compose
    freerdp
    mmex
  ];
  ironman = {
    network-profiles.work = true;
    personal_laptop = true;
    shares.personal = true;
  };
  networking.hostName = "friday";
  nix.settings.cores = 5;
  programs.steam = {
    enable = true;
    package = inputs.millennium.packages.${pkgs.stdenv.hostPlatform.system}.millennium-steam;
    protontricks.enable = true;
  };
  services.openssh.settings.PermitRootLogin = "no";
}
