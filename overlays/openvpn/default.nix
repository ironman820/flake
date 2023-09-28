{ channels, ... }:
final: prev:
{
  unixODBCDrivers = {
    mariadb = prev.unixODBCDrivers.mariadb;
    msodbcsql17 = prev.unixODBCDrivers.msodbcsql17.override { openssl = prev.openssl_1_1; };
    mysql = prev.unixODBCDrivers.mysql;
    psql = prev.unixODBCDrivers.psql;
    redshift = prev.unixODBCDrivers.redshift;
    sqlite = prev.unixODBCDrivers.sqlite;
  };
}
