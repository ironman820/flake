# mkBoolOpt

This is a version of the `mkOpt` function that declares the option with the type set to `bool` for you.

```nix
mkBoolOpt = mkOpt bool;
mkBoolOpt default description
```

Through a chain of expression definitions, this evaluates to:

```nix
mkOption {
  inherit default description;
  type = bool;
};
```

