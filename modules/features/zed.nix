{
  flake = {
    nixosModules.zed =
      { lib, ... }:
      let
        inherit (lib) mkOption types;
      in
      {
        options.ironman.zed_device = mkOption {
          type = types.str;
          default = "";
          description = "Device ID to set in the ZED_DEVICE_ID environment variable";
        };
      };
    homeModules = {
      zed = { lib, pkgs, ... }: {
        programs.zed-editor = {
          enable = true;
          extensions = [
            "dockerfile"
            "git-firefly"
            "html"
            "html-jinja"
            "jetbrains-icons"
            "jinja2"
            "log"
            "nix"
            "php"
            "scss"
            "tailwind-theme"
            "toml"
            "tokyo-night"
            "unicode"
            "xml"
          ];
          extraPackages = [
            pkgs.nixd
          ];
          userSettings = {
            ui_font_family = "DejaVu Sans";
            buffer_font_family = "FiraCode Nerd Font Mono";
            terminal.font_family = "IosevkaTerm Nerd Font Mono";
            semantic_tokens = "combined";
            languages.PHP.linked_edits = false;
            disable_ai = true;
            tab_size = 2;
            diff_view_style = "split";
            ssh_connections = [
              {
                host = "rcm.home";
                projects = [
                  {
                    paths = [
                      "/data/rcm"
                    ];
                  }
                ];
              }
              {
                host = "rcm2.home";
                projects = [
                  {
                    paths = [
                      "/data/rcm2/./"
                    ];
                  }
                ];
              }
            ];
            vim.toggle_relative_line_numbers = true;
            telemetry = {
              diagnostics = true;
              metrics = false;
            };
            vim_mode = true;
            base_keymap = "VSCode";
            icon_theme = "JetBrains Icons Dark";
            ui_font_size = 10;
            buffer_font_size = 9;
            terminal.font_size = 9;
            theme = lib.mkDefault "Tokyo Night";
          };
        };
      };
      zed-server = {
        programs.zed-editor = {
          enable = true;
          installRemoteServer = true;
        };
      };
    };
  };
}
