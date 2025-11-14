{
  flake.homeModules.btop = {
    programs.btop = {
      enable = true;
      settings = {
        color_theme = "tokyo-night";
        theme_background = false;
        truecolor = true;
        force_tty = false;
        presets = "cpu:1:default,proc:0:default cpu:0:default,mem:0:default,net:0:default cpu:0:block,net:0:tty";
        vim_keys = true;
        rounded_corners = true;
        graph_symbol = "braille";
        graph_symbol_cpu = "default";
        graph_symbol_gpu = "default";
        graph_symbol_mem = "default";
        graph_symbol_net = "default";
        graph_symbol_proc = "default";
        shown_boxes = "cpu mem net proc";
        update_ms = 2000;
        proc_sorting = "cpu lazy";
        proc_reversed = false;
        proc_tree = false;
        proc_colors = true;
        proc_gradient = true;
        proc_per_core = false;
        proc_mem_bytes = true;
        proc_cpu_graphs = true;
        proc_info_smaps = false;
        proc_left = false;
        proc_filter_kernel = false;
        proc_aggregate = false;
        cpu_graph_upper = "Auto";
        cpu_graph_lower = "Auto";
        show_gpu_info = "Auto";
        cpu_invert_lower = true;
        cpu_single_graph = false;
        cpu_bottom = false;
        show_uptime = true;
        check_temp = true;
        cpu_sensor = "Auto";
        show_coretemp = true;
        cpu_core_map = "";
        temp_scale = "celsius";
        base_10_sizes = false;
        show_cpu_freq = true;
        clock_format = "%X";
        background_update = true;
        custom_cpu_name = "";
        disks_filter = "";
        mem_graphs = true;
        mem_below_net = false;
        zfs_arc_cached = true;
        show_swap = true;
        swap_disk = true;
        show_disks = true;
        only_physical = true;
        use_fstab = true;
        zfs_hide_datasets = false;
        disk_free_priv = false;
        show_io_stat = true;
        io_mode = false;
        io_graph_combined = false;
        io_graph_speeds = "";
        net_download = 100;
        net_upload = 100;
        net_auto = true;
        net_sync = true;
        net_iface = "";
        show_battery = true;
        selected_battery = "Auto";
        log_level = "WARNING";
        nvml_measure_pcie_speeds = true;
        gpu_mirror_graph = true;
        custom_gpu_name0 = "";
        custom_gpu_name1 = "";
        custom_gpu_name2 = "";
        custom_gpu_name3 = "";
        custom_gpu_name4 = "";
        custom_gpu_name5 = "";
      };
      themes = {
        tokyo-night = ''
          # Theme: tokyo-night
          # By: Pascal Jaeger

          # Main bg
          theme[main_bg]="#1a1b26"

          # Main text color
          theme[main_fg]="#cfc9c2"

          # Title color for boxes
          theme[title]="#cfc9c2"

          # Highlight color for keyboard shortcuts
          theme[hi_fg]="#7dcfff"

          # Background color of selected item in processes box
          theme[selected_bg]="#414868"

          # Foreground color of selected item in processes box
          theme[selected_fg]="#cfc9c2"

          # Color of inactive/disabled text
          theme[inactive_fg]="#565f89"

          # Misc colors for processes box including mini cpu graphs, details memory graph and details status text
          theme[proc_misc]="#7dcfff"

          # Cpu box outline color
          theme[cpu_box]="#565f89"

          # Memory/disks box outline color
          theme[mem_box]="#565f89"

          # Net up/down box outline color
          theme[net_box]="#565f89"

          # Processes box outline color
          theme[proc_box]="#565f89"

          # Box divider line and small boxes line color
          theme[div_line]="#565f89"

          # Temperature graph colors
          theme[temp_start]="#9ece6a"
          theme[temp_mid]="#e0af68"
          theme[temp_end]="#f7768e"

          # CPU graph colors
          theme[cpu_start]="#9ece6a"
          theme[cpu_mid]="#e0af68"
          theme[cpu_end]="#f7768e"

          # Mem/Disk free meter
          theme[free_start]="#9ece6a"
          theme[free_mid]="#e0af68"
          theme[free_end]="#f7768e"

          # Mem/Disk cached meter
          theme[cached_start]="#9ece6a"
          theme[cached_mid]="#e0af68"
          theme[cached_end]="#f7768e"

          # Mem/Disk available meter
          theme[available_start]="#9ece6a"
          theme[available_mid]="#e0af68"
          theme[available_end]="#f7768e"

          # Mem/Disk used meter
          theme[used_start]="#9ece6a"
          theme[used_mid]="#e0af68"
          theme[used_end]="#f7768e"

          # Download graph colors
          theme[download_start]="#9ece6a"
          theme[download_mid]="#e0af68"
          theme[download_end]="#f7768e"

          # Upload graph colors
          theme[upload_start]="#9ece6a"
          theme[upload_mid]="#e0af68"
          theme[upload_end]="#f7768e"
        '';
      };
    };
  };
}
