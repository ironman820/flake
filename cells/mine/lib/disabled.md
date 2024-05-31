# disabled

This is shorthand to disable options.

Entering this:

```nix
<OPTION> = disabled;
```

Gets rendered as this in nix:

```nix
<OPTION> = {
  enable = false;
};
```
