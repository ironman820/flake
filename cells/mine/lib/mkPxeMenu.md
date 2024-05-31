# mkPxeMenu

This is a text expansion function that generates a menu file for PXE boot loaders. It takes a list of attribute sets and expands them out to the menu entries.

The args should be declared in this structure:
```nix
[
  {
    name = "NAME";
    value = {
      label = "menu label";
      kernel = "kernel image to use";
      append = "options to append to the kernel call";
    };
  };
];
```

The output would resemble this:

```
UI menu.c32
TIMEOUT 300
LABEL ${name}
  MENU LABEL ${value.label}
  KERNEL ${value.kernel}
  append ${value.append}
LABEL ${name2}
  MENU LABEL ${value2.label}
  KERNEL ${value2.kernel}
  append ${value2.append}
```

