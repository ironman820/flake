{
  cell,
  inputs,
}:
inputs.hive.findLoad {
  inherit cell inputs;
  block = ./.;
}
