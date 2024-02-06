{
  self,
  system,
  ...
}: final: prev: {
  inherit (self.packages.${system}) catppuccin-grub;
}
