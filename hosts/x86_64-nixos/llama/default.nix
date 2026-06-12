{
  config,
  inputs,
  pkgs,
  self,
  ...
}:
let
  # Import the pinned nixpkgs version for consistent kernel packages
  nvidia-pkgs = import inputs.nixpkgs-3652b3e {
    inherit (pkgs.stdenv.hostPlatform) system;
    config.allowUnfree = true;
  };

  # Use the pinned kernel packages and make sure we get a working kernel
  # Override the kernel directly to add attributes missing from the older nixpkgs
  # that newer nixpkgs modules expect to find on the kernel package
  pinnedKernelPackages =
    let
      base = nvidia-pkgs.linuxPackages_latest;
    in
    base
    // {
      kernel = base.kernel.overrideAttrs (_: {
        buildDTBs = false;
      });
    };
in
{
  imports = [
    ./hardware.nix
  ]
  ++ (with self.nixosModules; [
    base
    git
    proxmox
    tmux
    virtual-docker
    x64-linux
  ]);

  # Force the use of pinned kernel packages throughout the system
  boot.kernelPackages = pinnedKernelPackages;

  # Overlay to ensure all packages come from the pinned nixpkgs version
  nixpkgs.overlays = [
    (self: super: {
      linuxPackages_latest = pinnedKernelPackages;
      linuxPackages = pinnedKernelPackages;
      nvidia_x11 = nvidia-pkgs.nvidia_x11;
      # Ensure the kernel package itself comes from the pinned version
      # OverrideAttrs is needed because the older kernel lacks buildDTBs
      # that newer nixpkgs modules expect to read
      linux = pinnedKernelPackages.kernel.overrideAttrs (old: {
        buildDTBs = false;
      });
    })
  ];

  hardware = {
    deviceTree.enable = false; # older kernel at 9041993 lacks buildDTBs
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    nvidia = {
      modesetting.enable = true;
      open = true;
      package = config.boot.kernelPackages.nvidiaPackages.latest;
      nvidiaSettings = false;
      powerManagement = {
        enable = false;
        finegrained = false;
      };
    };
    nvidia-container-toolkit = {
      enable = true;
      # package = nvidia-pkgs.nvidia-container-toolkit;
    };
  };

  home-manager = {
    users.ironman = self.homeConfigurations.ironman-server;
  };

  networking.firewall.allowedTCPPorts = [
    8080
    11434
  ];

  nix.settings.cores = 4;

  security.sudo.wheelNeedsPassword = false;

  services = {
    openssh.settings.PermitRootLogin = "no";
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

  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      ollama = {
        autoRemoveOnStop = false;
        autoStart = true;
        image = "ollama/ollama";
        hostname = "ollama";
        devices = [
          "nvidia.com/gpu=all"
        ];
        extraOptions = [
          "--network=host"
        ];
        ports = [
          "11434:11434"
        ];
        volumes = [
          "/opt/appdata/apps/ollama:/root/.ollama"
        ];
      };
      openwebui = {
        autoRemoveOnStop = false;
        autoStart = true;
        image = "ghcr.io/open-webui/open-webui:main";
        hostname = "openwebui";
        extraOptions = [
          "--network=host"
        ];
        ports = [
          "8080:8080"
        ];
        volumes = [
          "/opt/appdata/openwebui/data:/app/backend/data"
        ];
        environment = {
          OLLAMA_BASE_URL = "http://127.0.0.1:11434";
        };
      };
    };
  };
}
