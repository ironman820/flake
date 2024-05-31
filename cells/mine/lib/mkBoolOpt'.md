# mkBoolOpt'

This is a prime version of the `mkBoolOpt` function that declares the option with a `null` description.

```nix
mkBoolOpt' = mkOpt' bool;
mkBoolOpt' default
```

Through a chain of expression definitions, this evaluates to:

```nix
mkOption {
  inherit default;
  type = bool;
  description = null;
};
```

