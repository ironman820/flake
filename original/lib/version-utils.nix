# Shared version utility functions
{ ... }:
{
  # Function to get first two components of a version string (major.minor)
  getVersionMajorMinor =
    version:
    let
      splitVersion = builtins.splitVersion version;
      major = builtins.head splitVersion;
      minor = builtins.elemAt splitVersion 1;
    in
    "${major}.${minor}";

  # Additional version utilities can be added here
}
