# mkOpt

This is a short-er hand declaration of the `mkOption` function.

```nix
mkOpt type default description
```

Through a chain of expression definitions, this evaluates to:

```nix
mkOption {
  inherit default description type;
};
```

