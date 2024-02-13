{channels, ...}: final: prev: {
  inherit (prev.ironman) idracclient switchssh;
}
