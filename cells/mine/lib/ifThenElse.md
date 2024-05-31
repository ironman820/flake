# ifThenElse

This is a quick expansion for `if ... then ... else ...` blocks in nix. The function takes three arguments:

```nix
ifThenElse condition if_true if_false
```

 - condition - This is the boolean expression to check
 - if_true - this is what is added after `then` (what to set/do if the condition is true)
 - if_false - this is what is added after `else` (what to set/do if the condition is false)

When evaluated, this returns the expression:

```nix
if ${condition}
then ${if_true}
else ${if_false};
```

