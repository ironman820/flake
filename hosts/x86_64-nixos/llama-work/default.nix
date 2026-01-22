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
    ollama = {
      enable = true;
      environmentVariables = {
        OLLAMA_CONTEXT_LENGTH = "32000";
        OLLAMA_KEEP_ALIVE = "-1";
        OLLAMA_FLASH_ATTENTION = "1";
      };
      host = "0.0.0.0";
      loadModels = [
        "qwen3-coder:30b"
      ];
      openFirewall = true;
      package = pkgs.ollama-rocm;
    };
    openssh.settings.PermitRootLogin = "no";
  };
  sops.secrets.llama_work_env = {
    sopsFile = "${flakeRoot}/.secrets/llama.yaml";
    mode = "0440";
  };
  systemd.services.ollama.serviceConfig = {
    EnvironmentFile = [ config.sops.secrets.llama_work_env.path ];
  };
  users.users.ironman.extraGroups = [
    "networkmanager"
  ];
}
