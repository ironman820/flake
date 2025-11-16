{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  pkgs,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "chicago95";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "grassmunk";
    repo = "Chicago95";
    rev = "v${finalAttrs.version}";
    hash = "sha256-EHcDIct2VeTsjbQWnKB2kwSFNb97dxuydAu+i/VquBA=";
  };

  nativeBuildInputs = with pkgs; [
    gtk3
    which
  ];

  buildInputs = with pkgs; [
    libcanberra
    libcanberra-gtk2
    libcanberra-gtk3
    sox
  ];

  buildPhase = ''
    runHook preBuild
    find . -xtype l -delete
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/themes
    mv Theme/Chicago95 $out/share/themes

    mkdir -p $out/share/icons
    mv Icons/Chicago95 $out/share/icons
    mv Cursors/* $out/share/icons/
    gtk-update-icon-cache $out/share/icons/Chicago95

    mkdir -p $out/share/sddm/themes
    tar -xzf KDE/SDDM/Chicago95.tar.gz -C "$out/share/sddm/themes/"

    mkdir -p $out/share/fonts
    cp Fonts/vga_font/* $out/share/fonts

    mkdir -p $out/share/sounds
    mv sounds/Chicago95 $out/share/sounds

    mkdir -p $out/share/lightdm-webkit/themes
    mv Lightdm/Chicago95 $out/share/lightdm-webkit/themes

    mkdir -p $out/share/plymouth/themes/
    mv Plymouth/Chicago95 $out/share/plymouth/themes
    substituteInPlace $out/share/plymouth/themes/Chicago95/Chicago95.plymouth --replace-fail "/usr/" "$out/"

    runHook postInstall
  '';

  meta = {
    description = "Windows 95 theme for GTK";
    homepage = "https://github.com/grassmunk/Chicago95";
    changelog = "https://github.com/grassmunk/Chicago95/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      gpl3Plus
      mit
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ GabrielMaguire ];
  };
})
