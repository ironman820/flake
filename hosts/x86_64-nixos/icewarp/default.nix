{
  config,
  inputs,
  self,
  ...
}:
{
  imports = [
    ./hardware.nix
    self.diskoConfigurations.icewarp
  ]
  ++ (with inputs; [
    arion.nixosModules.arion
    disko.nixosModules.disko
  ])
  ++ (with self.nixosModules; [
    base
    boot-systemd
    cloud-init
    git
    tmux
    virtual-docker
    x64-linux
  ]);
  home-manager = {
    users.royell = self.homeConfigurations.royell;
  };
  ironman.user = {
    name = "royell";
    email = {
      bob = "nic.eastman";
      site = "royell.org";
    };
  };
  nix.settings.cores = 4;
  security.sudo.wheelNeedsPassword = false;
  services = {
    qemuGuest.enable = true;
    xserver.enable = false;
  };
  users.users.royell.extraGroups = [
    "networkmanager"
    "docker"
  ];
  # virtualisation.arion = {
  #   backend = "docker";
  #   projects.llama.settings.services = {
  #     ollama.service = {
  #       image = "ollama/ollama";
  #       container_name = "ollama";
  #       devices = [
  #         "nvidia.com/gpu=all"
  #       ];
  #       ports = [
  #         "11434:11434"
  #       ];
  #       restart = "unless-stopped";
  #       volumes = [
  #         "/opt/appdata/apps/ollama:/root/.ollama"
  #       ];
  #     };
  #     openwebui.service = {
  #       image = "ghcr.io/open-webui/open-webui:main";
  #       container_name = "openwebui";
  #       ports = [
  #         "8080:8080"
  #       ];
  #       volumes = [
  #         "/opt/appdata/openwebui/data:/app/backend/data"
  #       ];
  #       environment = {
  #         OLLAMA_BASE_URL = "http://ollama:11434";
  #       };
  #       restart = "unless-stopped";
  #     };
  #   };
  # };
}
