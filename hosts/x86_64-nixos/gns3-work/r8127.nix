{
  stdenv,
  lib,
  fetchurl,
  kernel,
  kernelModuleMakeFlags,
  # pkgs,
  ...
}:

stdenv.mkDerivation (finalAttrs: rec {
  pname = "r8127";
  version = "11.015.00";

  src = fetchurl {
    url = "https://github.com/openwrt/rtl8127/archive/refs/tags/${version}.tar.gz";
    # sha256 = pkgs.lib.fakeSha256;
    sha256 = "sha256:0gqmzwqmhq8vizhm62cibkvdp7a33l46861jdwggw5is7aq9b7nq";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  preBuild = ''
    substituteInPlace Makefile --replace-fail "BASEDIR :=" "BASEDIR ?="
    substituteInPlace Makefile --replace-fail "modules_install" "INSTALL_MOD_PATH=$out modules_install"
  '';

  makeFlags = kernelModuleMakeFlags ++ [
    "BASEDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}"
  ];

  buildFlags = [ "modules" ];

  installPhase = ''
    mkdir -p $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/ethernet/realtek
    cp r8127.ko $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/ethernet/realtek/
  '';

  meta = {
    homepage = "https://github.com/openwrt/rtl8127/";
    description = "Realtek r8127 10G Ethernet driver";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.peelz ];
  };
})
