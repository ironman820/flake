{
  self,
  ...
}:
{
  flake.nixosModules.llamaWorkConfig = { config, pkgs, ... }: {
    boot = {
      kernelParams = [
        "amd_iommu=off"
        "amdgpu.gttsize=126976"
        "ttm.pages_limit=32505856"
      ];
    };
    environment.systemPackages = with pkgs.rocmPackages; [
      pkgs.huggingface-cli
      rocm-smi
      rocminfo
    ];
    hardware = {
      amdgpu.initrd.enable = true;
      facter.reportPath = ./facter.json;
      graphics = {
        enable = true;
        enable32Bit = true;
      };
    };
    ironman = {
      grub = false;
      server = {
        lxc = false;
        unattended = false;
      };
    };
    networking.hostName = "llama";
    nix.settings.cores = 8;
    sops.secrets.llama_work_env = {
      sopsFile = "${self.outPath}/.secrets/llama.yaml";
      mode = "0440";
    };
    systemd.services.ollama.serviceConfig = {
      EnvironmentFile = [ config.sops.secrets.llama_work_env.path ];
    };
    users.users.ironman.extraGroups = [
      "render"
      "video"
    ];
    virtualisation.oci-containers = {
      backend = "docker";
      containers.llama = {
        autoRemoveOnStop = false;
        autoStart = true;
        image = "docker.io/kyuz0/amd-strix-halo-toolboxes:rocm-10.0";
        hostname = "llama";
        devices = [
          "/dev/dri:/dev/dri"
          "/dev/kfd:/dev/kfd"
        ];
        environment = {
          LLAMA_ARG_MODEL = "/models/Qwen3.8-Flash-Next-AD-3.84bpw-IQ4_XS-M64-00001-of-00003.gguf";
          LLAMA_ARG_CTX_SIZE = "65536";
          LLAMA_ARG_N_GPU_LAYERS = "999";
          LLAMA_ARG_FLASH_ATTN = "on";
          LLAMA_ARG_MMAP = "disabled";
          LLAMA_ARG_HOST = "0.0.0.0";
          LLAMA_ARG_PORT = "8080";
        };
        environmentFiles = [
          config.sops.secrets.llama_work_env.path
        ];
        cmd = [
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
  };
}
