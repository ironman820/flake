from libqtile.config import Group, Key
from libqtile.command import lazy
# from libqtile.extension import CommandSet
from .keys import keys, mod

_groups: dict = {
    1: Group("󰆍"),
    2: Group("󰊯"),
}

for ws in range(3, 10):
    _groups.update({
        ws: Group(str(ws)),
    })

# projector_command = CommandSet(
#     commands={
#         "Single Display": '''
#             xrandr | grep -v -e "^ " | tail -1
#         '''
#     }
# )

groups: list[Group] = [_groups[group] for group in _groups]


def get_group_key(name: str):
    return [k for k, g in _groups.items() if g.name == name][0]


for group in groups:
    group_key = str(get_group_key(group.name))
    keys.extend([
        Key(
            [mod],
            group_key,
            lazy.group[group.name].toscreen(),
        ),
        Key(
            [mod, "shift"],
            group_key,
            lazy.window.togroup(group.name),
        ),
    ])
