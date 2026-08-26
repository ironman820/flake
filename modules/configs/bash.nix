{
  flake = {
    nixosModules.bash = {
      programs.bash.enable = true;
    };
    homeModules.bash = {
      programs = {
        bash = {
          enable = true;
          enableCompletion = true;
          enableVteIntegration = true;
          historyControl = [ "ignoreboth" ];
          historySize = 32768;
        };
        bashmount.enable = true;
      };
    };
  };
}
