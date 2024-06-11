{
  cell,
  inputs,
}: let
  inherit (inputs) nixpkgs;
  inherit (nixpkgs) writeShellScriptBin;
  inherit (nixpkgs.stdenv) mkDerivation;
  inherit (nixpkgs.tmuxPlugins) mkTmuxPlugin;
in {
  base16-onedark-scheme = mkDerivation {
    name = "base16-onedark-scheme";
    version = "2018-01-04";
    src = inputs.base16-schemes;
    buildPhase = ''
      mkdir -p $out
      cp $src/onedark.yaml $out/theme.yaml
    '';
    phases = "buildPhase";
  };
  catppuccin-neomutt = mkDerivation rec {
    buildPhase = ''
      mkdir -p $out
      cp -r $src/neomuttrc $out/catppuccin-neomutt
    '';
    name = pname;
    pname = "catppuccin-neomutt";
    phases = "buildPhase";
    src = inputs.catppuccin-neomutt;
  };
  cheat-sh = mkTmuxPlugin {
    pluginName = "cheat-sh";
    postInstall = ''
      sed -i -e "s|& cht\.sh|\& ${nixpkgs.cht-sh}/bin/cht.sh|g" $target/cheat.sh
    '';
    rtpFilePath = "cheat-sh.tmux";
    src = inputs.tmux-cheat-sh;
    version = "0.0.1";
  };
  networkmanagerapplet = nixpkgs.networkmanagerapplet.override {
    libnma = nixpkgs.libnma-gtk4;
  };
  open-android-backup = mkDerivation {
    buildPhase = ''
      mkdir -p $out/bin
      cp -r $src/* $out/bin/
      mv $out/bin/backup.sh $out/bin/open-android-backup
    '';
    name = "open-android-backup";
    propagatedBuildInputs = with nixpkgs; [
      bc
      curl
      dialog
      p7zip
      pv
    ];
    src = nixpkgs.fetchzip {
      hash = "sha256-ak3mOENbQ3W3iWZaEIabojaLfyatizs7tG2KSUgtAhM=";
      stripRoot = false;
      url = "https://github.com/mrrfv/open-android-backup/releases/download/v1.0.16/Open_Android_Backup_v1.0.16_Bundle.zip";
    };
    version = "1.0.16";
  };
  sddm-catppuccin = let
    inherit (nixpkgs.qt5) qtquickcontrols2;
    inherit (nixpkgs.qt6) qtbase qtsvg wrapQtAppsHook;
  in
    mkDerivation {
      dontBuild = true;
      pname = "sddm-catppuccin";
      version = "1.0";

      nativeBuildInputs = [
        qtbase
        wrapQtAppsHook
      ];

      propagatedUserEnvPkgs = [
        qtbase
        qtquickcontrols2
        qtsvg
      ];

      src = inputs.sddm-catppuccin;

      installPhase = ''
        mkdir -p $out/share/sddm/themes/catppuccin-mocha/
        cp $src/pertheme/mocha.conf $out/share/sddm/themes/catppuccin-mocha/theme.conf
        cp -R $src/src/* $out/share/sddm/themes/catppuccin-mocha/
      '';
    };
  tochd = let
    inherit (nixpkgs) p7zip mame-tools;
    inherit (nixpkgs.python3Packages) buildPythonApplication;
    tochd = buildPythonApplication rec {
      name = "tochd";
      pname = name;
      version = "1.1";

      propagatedBuildInputs = [
        p7zip
        mame-tools
      ];

      src = inputs.tochd;
    };
  in
    writeShellScriptBin "tochd" ''
      echo "${tochd}/bin/tochd.py --7z \"${p7zip}/bin/7z\" --chdman \"${mame-tools}/bin/chdman\" $@"
      ${tochd}/bin/tochd.py --7z "${p7zip}/bin/7z" --chdman "${mame-tools}/bin/chdman" $@
    '';
}
