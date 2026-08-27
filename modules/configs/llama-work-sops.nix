{ self, ... }: {
  flake.homeModules.llama-work-sops =
  { config, ...}:
  {
      programs.bash.initExtra = ''
        export $(cat ${config.sops.secrets.llama_work_env.path})
      '';
      sops.secrets.llama_work_env.sopsFile = "${self.outPath}/.secrets/llama.yaml";
  };
}
