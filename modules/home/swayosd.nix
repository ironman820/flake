{
  flake.homeModules.swayosd =
    { config, ... }:
    {
      services.swayosd = {
        enable = true;
        stylePath = "${config.xdg.configHome}/swayosd/style.css";
      };
      xdg.configFile = {
        "swayosd/config.toml".text = ''
          [server]
          show_percentage = true
          max_volume = 100
          style = "./style.css"
        '';
        "swayosd/style.css".text = ''
          @define-color background-color #1a1b26;
          @define-color border-color #33ccff;
          @define-color label #a9b1d6;
          @define-color image #a9b1d6;
          @define-color progress #a9b1d6;

          window {
            border-radius: 0;
            opacity: 0.97;
            border: 2px solid @border-color;

            background-color: @background-color;
          }

          label {
            font-family: 'CaskaydiaMono Nerd Font';
            font-size: 11pt;

            color: @label;
          }

          image {
            color: @image;
          }

          progressbar {
            border-radius: 0;
          }

          progress {
            background-color: @progress;
          }
        '';
      };
    };
}
