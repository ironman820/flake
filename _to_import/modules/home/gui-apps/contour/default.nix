{
  lib,
  config,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.mine) mkBoolOpt;
  inherit (lib.strings) floatToString;
  inherit (usrSettings.stylix.fonts) terminalSize;
  inherit (usrSettings.transparancy) terminalOpacity;

  cfg = config.mine.home.gui-apps.contour;
  os = osConfig.mine.gui-apps.contour;
  usrSettings = config.mine.home.user.settings;
in {
  options.mine.home.gui-apps.contour = {
    enable = mkBoolOpt os.enable "Enable the module";
  };
  config = mkIf cfg.enable {
    xdg.configFile."contour/contour.yml".text = ''
          platform_plugin: auto
      # VT Renderer configuration.
      # ADVANCED! Do not touch unless you know what you are doing.
          renderer:
              backend: OpenGL
              tile_hashtable_slots: 4096
              tile_cache_count: 4000
              tile_direct_mapping: true
          word_delimiters: " /\\()\"'-.,:;<>~!@#$%^&*+=[]{}~?|│"
          read_buffer_size: 16384
          pty_buffer_size: 1048576
          default_profile: main
          spawn_new_process: false
          reflow_on_resize: true
      # Bypasses an application blocking mouse highlighting
          bypass_mouse_protocol_modifier: Shift
      # Block selection
          mouse_block_selection_modifier: Control
      # Action on select: this mimicks Putty
          on_mouse_select: CopyToSelectionClipboard
      # Live reload the config
          live_config: true
      # Inline image related default configuration and limits
          images:
              # Enable or disable sixel scrolling (SM/RM ?80 default)
              sixel_scrolling: true
              # Configures the maximum number of color registers available when rendering Sixel graphics.
              sixel_register_count: 4096
              # maximum width in pixels of an image to be accepted (0 defaults to system screen pixel width)
              max_width: 0
              # maximum height in pixels of an image to be accepted (0 defaults to system screen pixel height)
              max_height: 0
      # Terminal Profiles
          profiles:
              main:
                  # It only makes sense to set this value to false if you really know what you are doing.
                  escape_sandbox: true
                  # Advanced value that is useful when CopyPreviousMarkRange is used
                  # with multiline-prompts. This offset value is being added to the
                  # current cursor's line number minus 1 (i.e. the line above the current cursor).
                  copy_last_mark_range_offset: 0
                  # Sets initial working directory when spawning a new terminal.
                  initial_working_directory: "~"
                  show_title_bar: false
                  fullscreen: false
                  maximized: false
                  wm_class: "contour"
                  terminal_id: VT525
                  # Determines the initial terminal size in characters.
                  terminal_size:
                      columns: 80
                      lines: 25
                  history:
                      # Number of lines to preserve (-1 for infinite).
                      limit: 1000
                      # Boolean indicating whether or not to scroll down to the bottom on screen updates.
                      auto_scroll_on_update: true
                      # Number of lines to scroll on ScrollUp & ScrollDown events.
                      scroll_multiplier: 3
                  # visual scrollbar support
                  scrollbar:
                      position: Hidden
                      hide_in_alt_screen: true
                  mouse:
                      # whether or not to hide mouse when typing
                      hide_while_typing: true
                  permissions:
                      change_font: ask
                      capture_buffer: ask
                      display_host_writable_statusline: ask
                  highlight_word_and_matches_on_double_click: false
                  font:
                      size: ${floatToString terminalSize}
                      dpi_scale: 1.0
                      locator: native
                      text_shaping:
                          engine: native
                      builtin_box_drawing: true
                      render_mode: lcd
                      strict_spacing: true
                      regular:
                          family: "${osConfig.stylix.fonts.monospace.name}"
                          weight: regular
                          slant: normal
                          features: []
                      emoji: "emoji"
                  draw_bold_text_with_bright_colors: true
                  cursor:
                      shape: "bar"
                      blinking: true
                      blinking_interval: 500
                  normal_mode:
                      cursor:
                          shape: block
                          blinking: true
                          blinking_interval: 700
                  visual_mode:
                      cursor:
                          shape: block
                          blinking: false
                          blinking_interval: 500
                  vi_mode_highlight_timeout: 300
                  vi_mode_scrolloff: 8
                  status_line:
                      display: indicator
                      position: bottom
                      sync_to_window_title: false
                  background:
                      opacity: ${toString terminalOpacity}
                      # Currently only Windows 10 is supported.
                      blur: false
                  colors: "catppuccin_mocha"
                  hyperlink_decoration:
                      normal: dotted
                      hover: underline

      # Color Profiles
          color_schemes:
              default:
                  default:
                      background: '#1a1716'
                      foreground: '#d0d0d0'
                  background_image:
                      opacity: 0.5
                      blur: false
                  cursor:
                      default: CellForeground
                      text: CellBackground
                  hyperlink_decoration:
                      normal: '#f0f000'
                      hover: '#ff0000'
                  vi_mode_highlight:
                      foreground: CellForeground
                      foreground_alpha: 1.0
                      background: '#ffa500'
                      background_alpha: 0.5
                  vi_mode_cursorline:
                      foreground: '#ffffff'
                      foreground_alpha: 0.2
                      background: '#808080'
                      background_alpha: 0.4
                  selection:
                      foreground: CellForeground
                      foreground_alpha: 1.0
                      background: '#4040f0'
                      background_alpha: 0.5
                  search_highlight:
                      foreground: CellBackground
                      background: CellForeground
                      foreground_alpha: 1.0
                      background_alpha: 1.0
                  search_highlight_focused:
                      foreground: CellBackground
                      background: CellForeground
                      foreground_alpha: 1.0
                      background_alpha: 1.0
                  word_highlight_current:
                      foreground: CellForeground
                      background: '#909090'
                      foreground_alpha: 1.0
                      background_alpha: 0.5
                  word_highlight_other:
                      foreground: CellForeground
                      background: '#909090'
                      foreground_alpha: 1.0
                      background_alpha: 0.5
                  indicator_statusline:
                      foreground: '#808080'
                      background: '#000000'
                  indicator_statusline_inactive:
                      foreground: '#808080'
                      background: '#000000'
                  input_method_editor:
                      foreground: '#FFFFFF'
                      background: '#FF0000'
                  normal:
                      black:   '#000000'
                      red:     '#c63939'
                      green:   '#00a000'
                      yellow:  '#a0a000'
                      blue:    '#4d79ff'
                      magenta: '#ff66ff'
                      cyan:    '#00a0a0'
                      white:   '#c0c0c0'
                  bright:
                      black:   '#707070'
                      red:     '#ff0000'
                      green:   '#00ff00'
                      yellow:  '#ffff00'
                      blue:    '#0000ff'
                      magenta: '#ff00ff'
                      cyan:    '#00ffff'
                      white:   '#ffffff'
              catppuccin_mocha:
                default:
                    background: "#1E1E2E" # base
                    foreground: "#CDD6F4" # text
                cursor:
                    default: "#F5E0DC" # rosewater
                    text: "#1E1E2E" # base
                normal:
                    black: "#45475A" # surface1
                    red: "#F38BA8" # red
                    green: "#A6E3A1" # green
                    yellow: "#F9E2AF" # yellow
                    blue: "#89B4FA" # blue
                    magenta: "#F5C2E7" # pink
                    cyan: "#94E2D5" # teal
                    white: "#BAC2DE" # subtext1
                bright:
                    black: "#585B70" # surface2
                    red: "#F38BA8" # red
                    green: "#A6E3A1" # green
                    yellow: "#F9E2AF" # yellow
                    blue: "#89B4FA" # blue
                    magenta: "#F5C2E7" # pink
                    cyan: "#94E2D5" # teal
                    white: "#A6ADC8" # subtext0
      # Key Bindings
      # ------------
      #
      # In this section you can customize key bindings.
      # Each array element in `input_mapping` represents one key binding,
      # whereas `mods` represents an array of keyboard modifiers that must be pressed - as well as
      # the `key` or `mouse` -  in order to activate the corresponding action,
      #
      # Additionally one can filter input mappings based on special terminal modes using the `modes` option:
      # - Alt       : The terminal is currently in alternate screen buffer, otherwise it is in primary screen buffer.
      # - AppCursor : The application key cursor mode is enabled (otherwise it's normal cursor mode).
      # - AppKeypad : The application keypad mode is enabled (otherwise it's the numeric keypad mode).
      # - Select    : The terminal has currently an active grid cell selection (such as selected text).
      # - Insert    : The Insert input mode is active, that is the default and one way to test
      #               that the input mode is not in normal mode or any of the visual select modes.
      # - Search    : There is a search term currently being edited or already present.
      # - Trace     : The terminal is currently in trace-mode, i.e., each VT sequence can be interactively
      #               single-step executed using custom actions. See TraceEnter/TraceStep/TraceLeave actions.
      #
      # You can combine these modes by concatenating them via | and negate a single one
      # by prefixing with ~.
      #
      # The `modes` option defaults to not filter at all (the input mappings always
      # match based on modifier and key press / mouse event).
      #
      # `key` represents keys on your keyboard, and `mouse` represents buttons
      # as well as the scroll wheel.
      #
      # Modifiers:
      # - Alt
      # - Control
      # - Shift
      # - Meta (this is the Windows key on Windows OS, and the Command key on OS/X, and Meta on anything else)
      #
      # Keys can be expressed case-insensitively symbolic:
      #   APOSTROPHE, ADD, BACKSLASH, COMMA, DECIMAL, DIVIDE, EQUAL, LEFT_BRACKET,
      #   MINUS, MULTIPLY, PERIOD, RIGHT_BRACKET, SEMICOLON, SLASH, SUBTRACT, SPACE
      #   Enter, Backspace, Tab, Escape, F1, F2, F3, F4, F5, F6, F7, F8, F9, F10, F11, F12,
      #   DownArrow, LeftArrow, RightArrow, UpArrow, Insert, Delete, Home, End, PageUp, PageDown,
      #   Numpad_NumLock, Numpad_Divide, Numpad_Multiply, Numpad_Subtract, Numpad_CapsLock,
      #   Numpad_Add, Numpad_Decimal, Numpad_Enter, Numpad_Equal,
      #   Numpad_0, Numpad_1, Numpad_2, Numpad_3, Numpad_4,
      #   Numpad_5, Numpad_6, Numpad_7, Numpad_8, Numpad_9
      # or in case of standard characters, just the character.
      #
      # Mouse buttons can be one of the following self-explanatory ones:
      #   Left, Middle, Right, WheelUp, WheelDown
      #
      # Actions:
      # - CancelSelection   Cancels currently active selection, if any.
      # - ChangeProfile     Changes the profile to the given profile `name`.
      # - ClearHistoryAndReset    Clears the history, performs a terminal hard reset and attempts to force a redraw of the currently running application.
      # - CopyPreviousMarkRange   Copies the most recent range that is delimited by vertical line marks into clipboard.
      # - CopySelection     Copies the current selection into the clipboard buffer.
      # - DecreaseFontSize  Decreases the font size by 1 pixel.
      # - DecreaseOpacity   Decreases the default-background opacity by 5%.
      # - FocusNextSearchMatch     Focuses the next search match (if any).
      # - FocusPreviousSearchMatch Focuses the next previous match (if any).
      # - FollowHyperlink   Follows the hyperlink that is exposed via OSC 8 under the current cursor position.
      # - IncreaseFontSize  Increases the font size by 1 pixel.
      # - IncreaseOpacity   Increases the default-background opacity by 5%.
      # - NewTerminal       Spawns a new terminal at the current terminals current working directory.
      # - NoSearchHighlight Disables current search highlighting, if anything is still highlighted due to a prior search.
      # - OpenConfiguration Opens the configuration file.
      # - OpenFileManager   Opens the current working directory in a system file manager.
      # - PasteClipboard    Pastes clipboard to standard input. Pass boolean parameter 'strip' to indicate whether or not to strip repetitive whitespaces down to one and newlines to whitespaces.
      # - PasteSelection    Pastes current selection to standard input.
      # - Quit              Quits the application.
      # - ReloadConfig      Forces a configuration reload.
      # - ResetConfig       Overwrites current configuration with builtin default configuration and loads it. Attention, all your current configuration will be lost due to overwrite!
      # - ResetFontSize     Resets font size to what is configured in the config file.
      # - ScreenshotVT      Takes a screenshot in form of VT escape sequences.
      # - ScrollDown        Scrolls down by the multiplier factor.
      # - ScrollMarkDown    Scrolls one mark down (if none present, bottom of the screen)
      # - ScrollMarkUp      Scrolls one mark up
      # - ScrollOneDown     Scrolls down by exactly one line.
      # - ScrollOneUp       Scrolls up by exactly one line.
      # - ScrollPageDown    Scrolls a page down.
      # - ScrollPageUp      Scrolls a page up.
      # - ScrollToBottom    Scrolls to the bottom of the screen buffer.
      # - ScrollToTop       Scrolls to the top of the screen buffer.
      # - ScrollUp          Scrolls up by the multiplier factor.
      # - SearchReverse     Initiates search mode (starting to search at current cursor position, moving upwards).
      # - SendChars         Writes given characters in `chars` member to the applications input.
      # - ToggleAllKeyMaps  Disables/enables responding to all keybinds (this keybind will be preserved when disabling all others).
      # - ToggleFullScreen  Enables/disables full screen mode.
      # - ToggleInputProtection Enables/disables terminal input protection.
      # - ToggleStatusLine  Shows/hides the VT320 compatible Indicator status line.
      # - ToggleTitleBar    Shows/Hides titlebar
      # - TraceBreakAtEmptyQueue Executes any pending VT sequence from the VT sequence buffer in trace mode, then waits.
      # - TraceEnter        Enables trace mode, suspending execution until explicitly requested to continue (See TraceLeave and TraceStep).
      # - TraceLeave        Disables trace mode. Any pending VT sequence will be flushed out and normal execution will be resumed.
      # - TraceStep         Executes a single VT sequence that is to be executed next.
      # - ViNormalMode      Enters/Leaves Vi-like normal mode. The cursor can then be moved via h/j/k/l movements in normal mode and text can be selected via v, yanked via y, and clipboard pasted via p.
      # - WriteScreen       Writes VT sequence in `chars` member to the screen (bypassing the application).

          input_mapping:
              - { mods: [Control],        mouse: Left,        action: FollowHyperlink }
              - { mods: [],               mouse: Middle,      action: PasteSelection }
              - { mods: [],               mouse: WheelDown,   action: ScrollDown }
              - { mods: [],               mouse: WheelUp,     action: ScrollUp }
              - { mods: [Alt],            key: Enter,         action: ToggleFullscreen }
              - { mods: [Alt],            mouse: WheelDown,   action: DecreaseOpacity }
              - { mods: [Alt],            mouse: WheelUp,     action: IncreaseOpacity }
              - { mods: [Control, Alt],   key: S,             action: ScreenshotVT }
              - { mods: [Control, Shift], key: Plus,          action: IncreaseFontSize }
              - { mods: [Control],        key: '0',           action: ResetFontSize }
              - { mods: [Control, Shift], key: Minus,         action: DecreaseFontSize }
              - { mods: [Control, Shift], key: '_',           action: DecreaseFontSize }
              - { mods: [Control, Shift], key: N,             action: NewTerminal }
              - { mods: [Control, Shift], key: V,             action: PasteClipboard, strip: false }
              - { mods: [Control, Alt],   key: V,             action: PasteClipboard, strip: true }
              - { mods: [Control],        key: C,             action: CopySelection, mode: 'Select|Insert' }
              - { mods: [Control],        key: C,             action: CancelSelection, mode: 'Select|Insert' }
              - { mods: [Control],        key: V,             action: PasteClipboard, strip: false, mode: 'Select|Insert' }
              - { mods: [Control],        key: V,             action: CancelSelection, mode: 'Select|Insert' }
              - { mods: [],               key: Escape,        action: CancelSelection, mode: 'Select|Insert' }
              - { mods: [Control, Shift], key: Space,         action: ViNormalMode, mode: 'Insert' }
              - { mods: [Control, Shift], key: Comma,         action: OpenConfiguration }
              - { mods: [Control, Shift], key: Q,             action: Quit }
              - { mods: [Control],        mouse: WheelDown,   action: DecreaseFontSize }
              - { mods: [Control],        mouse: WheelUp,     action: IncreaseFontSize }
              - { mods: [Shift],          key: DownArrow,     action: ScrollOneDown }
              - { mods: [Shift],          key: End,           action: ScrollToBottom }
              - { mods: [Shift],          key: Home,          action: ScrollToTop }
              - { mods: [Shift],          key: PageDown,      action: ScrollPageDown }
              - { mods: [Shift],          key: PageUp,        action: ScrollPageUp }
              - { mods: [Shift],          key: UpArrow,       action: ScrollOneUp }
              - { mods: [Control, Alt],   key: K,             action: ScrollMarkUp,   mode: "~Alt"}
              - { mods: [Control, Alt],   key: J,             action: ScrollMarkDown, mode: "~Alt"}
              - { mods: [Shift],          mouse: WheelDown,   action: ScrollPageDown }
              - { mods: [Shift],          mouse: WheelUp,     action: ScrollPageUp }
              - { mods: [Control, Alt],   key: O,             action: OpenFileManager }
              - { mods: [Control, Alt],   key: '.',           action: ToggleStatusLine }
              - { mods: [Control, Shift], key: 'F',           action: SearchReverse }
              - { mods: [Control, Shift], key: 'H',           action: NoSearchHighlight }
              - { mods: [],               key: 'F3',          action: FocusNextSearchMatch }
              - { mods: [Shift],          key: 'F3',          action: FocusPreviousSearchMatch }

      #   - { mods: [Control, Meta],  key: 'E',           action: TraceEnter,             mode: "~Trace" }
      #   - { mods: [Control, Meta],  key: 'E',           action: TraceLeave,             mode: "Trace" }
      #   - { mods: [Control, Meta],  key: 'N',           action: TraceStep,              mode: "Trace" }
      #   - { mods: [Control, Meta],  key: 'F',           action: TraceBreakAtEmptyQueue, mode: "Trace" }
      # color_schemes:
      # # default_profile:
      # live_config: true
      # profiles:
      #   main:
      #     colors: "catppucin_mocha"
      #     font:
      #       regular:
      #         family: "IosevkaTerm Nerd Font"
      #         weight: "normal"
      #         slant: "normal"
      #       size: 6
    '';
  };
}
