# mkOpt'

This is a prime version of the `mkOpt` function that declares the option with the description set to `null`.

```nix
mkOpt' = mkOpt type default null;
mkOpt' type default
```

Through a chain of expression definitions, this evaluates to:

```nix
mkOption {
  inherit default type;
  description = null;
};
```

