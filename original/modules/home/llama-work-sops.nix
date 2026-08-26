{
  flake.homeModules.llama-work-sops =
  { config, flakeRoot, ...}:
  {
      programs.bash.initExtra = ''
        export ''$(cat ${config.sops.secrets.llama_work_env.path})
      '';
      sops.secrets.llama_work_env.sopsFile = "${flakeRoot}/.secrets/llama.yaml";
  };
}
