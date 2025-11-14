{
  config,
  flakeRoot,
  inputs,
  pkgs,
  self,
  ...
}:
{
  imports = [
    ./hardware.nix
  ]
  ++ (with inputs; [
    darkmatter-grub-theme.nixosModule
    disko.nixosModules.disko
  ])
  ++ (with self.nixosModules; [
    base
    boot-grub
    self.diskoConfigurations.llama-work
    git
    tmux
    x64-linux
  ]);
  boot = {
    extraModulePackages = [
      (pkgs.callPackage ./r8127.nix {
        inherit (builtins) fetchurl;
        kernel = pkgs.linux;
        kernelModuleMakeFlags = pkgs.linux.modules.commonMakeFlags;
      })
    ];
    kernelParams = [
      "amd_iommu=off"
      "amdgpu.gttsize=131072"
      "ttm.pages_limit=33554432"
    ];
  };
  hardware = {
    amdgpu.initrd.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
  home-manager = {
    users.ironman = self.homeConfigurations.ironman-server;
  };
  nix.settings.cores = 8;
  security.sudo.wheelNeedsPassword = false;
  services = {
    llama-cpp = {
      enable = true;
      extraFlags = [
        "--no-mmap"
        "-ngl"
        "999"
        "-fa"
        "1"
        "-c"
        "0"
      ];
      host = "0.0.0.0";
      model = "/models/Qwen3-Coder-30B-A3B-Instruct-GGUF/BF16/Qwen3-Coder-30B-A3B-Instruct-BF16-00001-of-00002.gguf";
      openFirewall = true;
      package = pkgs.llama-cpp-rocm;
    };
  };
  sops.secrets.llama_work_env = {
    sopsFile = "${flakeRoot}/.secrets/llama.yaml";
    mode = "0440";
  };
  systemd.services.llama-cpp.serviceConfig = {
    EnvironmentFile = [ config.sops.secrets.llama_work_env.path ];
  };
  users.users.ironman.extraGroups = [
    "networkmanager"
  ];
}
