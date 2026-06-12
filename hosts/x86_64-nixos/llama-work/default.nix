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
    inputs.darkmatter-grub-theme.nixosModule
    inputs.disko.nixosModules.disko
    self.nixosModules.base
    self.nixosModules.boot-grub
    self.nixosModules.virtual-docker
    self.nixosModules.git
    self.nixosModules.tmux
    self.nixosModules.x64-linux
    self.diskoConfigurations.llama-work
  ];
  boot = {
    kernelParams = [
      "amd_iommu=off"
      "amdgpu.gttsize=126976"
      "ttm.pages_limit=32505856"
    ];
  };
  environment.systemPackages = with pkgs.rocmPackages; [
    rocm-smi
    rocminfo
  ];
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
  networking.firewall.allowedTCPPorts = [
    8080
  ];
  nix.settings.cores = 8;
  security.sudo.wheelNeedsPassword = false;
  services.openssh.settings.PermitRootLogin = "no";
  sops.secrets.llama_work_env = {
    sopsFile = "${flakeRoot}/.secrets/llama.yaml";
    mode = "0440";
  };
  systemd.services.ollama.serviceConfig = {
    EnvironmentFile = [ config.sops.secrets.llama_work_env.path ];
  };
  users.users.ironman.extraGroups = [
    "docker"
    "networkmanager"
    "render"
    "video"
  ];
  virtualisation.oci-containers = {
    backend = "docker";
    containers.llama = {
      autoRemoveOnStop = false;
      autoStart = true;
      image = "docker.io/kyuz0/amd-strix-halo-toolboxes:rocm-6.4.4";
      hostname = "llama";
      devices = [
        "/dev/dri:/dev/dri"
        "/dev/kfd:/dev/kfd"
      ];
      environment = {
        LLAMA_ARG_MODEL = "/models/Qwen3.6-35B-A3B-UD-Q4_K_XL.gguf";
        LLAMA_ARG_CTX_SIZE = "65536";
        LLAMA_ARG_N_GPU_LAYERS = "999";
        LLAMA_ARG_FLASH_ATTN = "on";
        LLAMA_ARG_MMAP = "disabled";
        LLAMA_ARG_HOST = "0.0.0.0";
      };
      environmentFiles = [
        config.sops.secrets.llama_work_env.path
      ];
      cmd = [
        # "tail"
        # "-f"
        # "/dev/null"
        "/bin/bash"
        "-c"
        "llama-server"
      ];
      extraOptions = [
        "--group-add"
        "render"
        "--group-add"
        "video"
        "--security-opt"
        "seccomp=unconfined"
        "--ipc=host"
        "--network=host"
      ];
      volumes = [
        "/home/ironman/models:/models"
      ];
    };
  };
}
