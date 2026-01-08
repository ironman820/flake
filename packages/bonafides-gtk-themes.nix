{
  inputs,
  lib,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "bonafides-gtk-themes";
  version = "2025.12.18";

  src = inputs.bonafides-themes;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/themes
    cp -R "BonaFides GTK Themes/BonaFides-Dark-GTK" $out/share/themes/
    cp -R "BonaFides GTK Themes/BonaFides-Nord-Dark-GTK" $out/share/themes/

    runHook postInstall
  '';

  meta = {
    description = "BonaFides Themes For Desktop";
    homepage = "https://github.com/L4ki/BonaFides-Plasma-Themes";
    license = with lib.licenses; [
      gpl3Plus
      mit
    ];
    platforms = lib.platforms.linux;
  };
})
