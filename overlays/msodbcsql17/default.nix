{ channels, ... }:
final: prev:
{
  msodbcsql17 = prev.msodbcsql17.override { openssl = prev.openssl_1_1; };
}
