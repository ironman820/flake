{ self, ... }:
{
  flake.homeModules.extra = { lib, pkgs, ... }: {
    imports = with self.homeModules; [
      podman
      yubikey
    ];
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
      extraPackages = with pkgs; [
        nixd
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
        ui_font_size = 16;
        buffer_font_size = 15;
        theme = lib.mkDefault "Tokyo Night";
      };
    };
    services.udiskie = {
      enable = true;
      tray = "never";
    };
  };
}
