{ channels }:
let
  # adoptopenjdk-icedtea-web = import ./adoptopenjdk-icedtea-web { inherit channels; };
  brave = import ./brave { inherit channels; };
  google-chrome = import ./google-chrome { inherit channels; };
  msodbcsql17 = import ./msodbcsql17 { inherit channels; };
  nvim = import ./nvim { inherit channels; };
  # oraclejdk8 = import ./oraclejdk8 { inherit channels; };
  # oraclejdk8-files = import ./oraclejdk8-files { inherit channels; };
  # php7 = import ./php7 { inherit channels; };
  # qt6 = import ./qt6 { inherit channels; };
  # unixODBCDrivers = import ./unixODBCDrivers { inherit channels; };
  # vaapiIntel = import ./vaapiIntel { inherit channels; };
  vscode = import ./vscode { inherit channels; };
in
[
  # adoptopenjdk-icedtea-web
  brave
  google-chrome
  msodbcsql17
  nvim
  # php7
  vscode
]
