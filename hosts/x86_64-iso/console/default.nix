{
  modulesPath,
  self,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix")
    (modulesPath + "/installer/cd-dvd/channel.nix")
  ]
  ++ (with self.nixosModules; [
    network-profiles
    x64-linux
  ]);
  boot = {
    kernelParams = [ "console=ttyS0,115200n8" ];
  };
  ironman = {
    network-profiles.work = true;
  };
  isoImage.squashfsCompression = "gzip -Xcompression-level 1";
  networking.hostName = "nixos";
  nix.settings.cores = 1;
}
