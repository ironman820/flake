{ channels, ... }:
final: prev:
{
  unixODBCDrivers = prev.unixODBCDrivers // {
    msodbcsql17 = prev.unixODBCDrivers.msodbcsql17.override { openssl = prev.openssl_1_1; };
  };
}
