{
  config,
  inputs,
  pkgs,
  self,
  ...
}:
let
  nvidia-pkgs = import inputs.nixpkgs-9041993 {
    inherit (pkgs.stdenv.hostPlatform) system;
    config.allowUnfree = true;
  };
  pinnedKernelPackages = nvidia-pkgs.linuxPackages_latest;
in
{
  imports = [
    ./hardware.nix
  ]
  ++ (with inputs; [
    arion.nixosModules.arion
  ])
  ++ (with self.nixosModules; [
    base
    git
    proxmox
    tmux
    virtual-docker
    x64-linux
  ]);
  boot.kernelPackages = pinnedKernelPackages;
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    nvidia = {
      modesetting.enable = true;
      open = false;
      package = config.boot.kernelPackages.nvidiaPackages.latest;
      nvidiaSettings = true;
      powerManagement.enable = true;
    };
    nvidia-container-toolkit = {
      enable = true;
      package = nvidia-pkgs.nvidia-container-toolkit;
    };
  };
  home-manager = {
    users.ironman = self.homeConfigurations.ironman-server;
  };
  nix.settings.cores = 4;
  nixpkgs.config = {
    packageOverrides = pkgs: {
      linuxPackages_latest = pinnedKernelPackages;
      nvidia_x11 = nvidia-pkgs.nvidia_x11;
    };
  };
  security.sudo.wheelNeedsPassword = false;
  services = {
    qemuGuest.enable = true;
    xserver = {
      enable = false;
      videoDrivers = [ "nvidia" ];
    };
  };
  users.users.ironman.extraGroups = [
    "networkmanager"
    "docker"
  ];
  virtualisation.arion = {
    backend = "docker";
    projects.llama.settings.services = {
      ollama.service = {
        image = "ollama/ollama";
        container_name = "ollama";
        devices = [
          "nvidia.com/gpu=all"
        ];
        ports = [
          "11434:11434"
        ];
        restart = "unless-stopped";
        volumes = [
          "/opt/appdata/apps/ollama:/root/.ollama"
        ];
      };
      openwebui.service = {
        image = "ghcr.io/open-webui/open-webui:main";
        container_name = "openwebui";
        ports = [
          "8080:8080"
        ];
        volumes = [
          "/opt/appdata/openwebui/data:/app/backend/data"
        ];
        environment = {
          OLLAMA_BASE_URL = "http://ollama:11434";
        };
        restart = "unless-stopped";
      };
    };
  };
}
