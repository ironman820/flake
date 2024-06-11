from libqtile.config import Key, KeyChord
from libqtile.command import lazy

browser: str = "brave"
rofi: str = "rofi -show drun -show-icons"
terminal: str = "kitty"
ranger = f"{terminal} bash -c ranger ~"
mod: str = "mod4"

keys = [
    KeyChord(
        [mod],
        "p",
        [
            Key(
                [],
                "e",
                lazy.spawn(
                    " ".join(
                        [
                            "xrandr --output DP-1 --primary --auto --output",
                            "eDP-1 --off",
                        ]
                    )
                ),
            ),
            Key(
                ["shift"],
                "e",
                lazy.spawn(
                    " ".join(
                        [
                            "xrandr --output eDP-1 --primary --auto --output",
                            "HDMI-1 --mode 1280x720 --right-of eDP-1",
                        ]
                    )
                ),
            ),
            Key(
                [],
                "p",
                lazy.spawn(
                    " ".join(
                        [
                            "xrandr --output eDP-1 --primary --auto --output",
                            "DP-1 --off --output HDMI-1 --off",
                        ]
                    )
                ),
            ),
            Key(
                [],
                "m",
                lazy.spawn(
                    " ".join(
                        [
                            "xrandr --output eDP-1 --mode 1280x720 --primary",
                            "--output HDMI-1 --mode 1280x720 --same-as eDP-1",
                        ]
                    )
                ),
            ),
        ],
    ),
    Key([], "Print", lazy.spawn("flameshot launcher")),
    Key([], "XF86AudioMute", lazy.widget["pulsevolume"].mute()),
    Key([], "XF86AudioLowerVolume", lazy.widget["pulsevolume"].decrease_vol()),
    Key([], "XF86AudioRaiseVolume", lazy.widget["pulsevolume"].increase_vol()),
    Key(
        [],
        "XF86MonBrightnessDown",
        lazy.widget["backlight"].change_backlight("down"),
    ),
    Key(
        [],
        "XF86MonBrightnessUp",
        lazy.widget["backlight"].change_backlight("up"),
    ),
    Key([mod], "f", lazy.spawn(ranger), desc="Move focus to left"),
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod], "r", lazy.spawn(rofi), desc="Spawn a command using rofi"),
    Key([mod], "t", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "w", lazy.spawn(browser), desc="Launch browser"),
    Key(
        [mod],
        "space",
        lazy.layout.next(),
        desc="Move window focus to other window",
    ),
    Key(
        [mod, "shift"],
        "h",
        lazy.layout.shuffle_left(),
        desc="Move window to the left",
    ),
    Key(
        [mod, "shift"],
        "l",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    Key(
        [mod, "shift"],
        "j",
        lazy.layout.shuffle_down(),
        desc="Move window down",
    ),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    Key(
        [mod, "shift"],
        "n",
        lazy.window.toggle_floating(),
        desc="Toggle Floating window",
    ),
    Key(
        [mod, "control"],
        "h",
        lazy.layout.grow_left(),
        desc="Grow window to the left",
    ),
    Key(
        [mod, "control"],
        "l",
        lazy.layout.grow_right(),
        desc="Grow window to the right",
    ),
    Key(
        [mod, "control"],
        "j",
        lazy.layout.grow_down(),
        desc="Grow window down",
    ),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
]
