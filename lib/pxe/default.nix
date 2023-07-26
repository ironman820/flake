{ lib, ... }:
with lib;
rec {
  mkPxeMenu = args: ''
    UI menu.c32
    TIMEOUT 300
  '' +
  strings.concatStringsSep "\n" (mapAttrsToList
    (name: value:
      ''
        LABEL ${name}
          MENU LABEL ${value.content.label}
          KERNEL ${value.content.kernel}
          append ${value.content.append}
      ''
    )
    (filterAttrs (_: v: v.condition) args));
}
