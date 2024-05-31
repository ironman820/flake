# enabled

This is shorthand to enable options.

Entering this:

```nix
<OPTION> = enabled;
```

Gets rendered as this in nix:

```nix
<OPTION> = {
  enable = true;
};
```
