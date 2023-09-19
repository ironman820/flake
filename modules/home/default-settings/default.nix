{ config, lib, pkgs, system, ...}:
with lib;
with lib.ironman;
{
  config = {
    ironman.home.nvim = enabled;
  };
}
