{
  cell,
  inputs,
}: let
  inherit (inputs) nixpkgs;
  inherit (nixpkgs) writeShellScriptBin;
  inherit (nixpkgs.stdenv) mkDerivation;
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
  networkmanagerapplet = nixpkgs.networkmanagerapplet.override {
    libnma = nixpkgs.libnma-gtk4;
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
