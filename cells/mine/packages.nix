{
  cell,
  inputs,
}: let
  inherit (inputs) nixpkgs tmux-sessionx;
  inherit (nixpkgs) writeScriptBin writeShellScriptBin;
  inherit (nixpkgs.stdenv) mkDerivation;
  inherit (nixpkgs.tmuxPlugins) mkTmuxPlugin;
  inherit (nixpkgs.vimUtils) buildVimPlugin;
in {
  inherit (cell.overlays) openssh;
  # base16-onedark-scheme = mkDerivation {
  #   name = "base16-onedark-scheme";
  #   version = "2018-01-04";
  #   src = inputs.base16-schemes;
  #   buildPhase = ''
  #     mkdir -p $out
  #     cp $src/onedark.yaml $out/theme.yaml
  #   '';
  #   phases = "buildPhase";
  # };
  # catppuccin-neomutt = mkDerivation rec {
  #   buildPhase = ''
  #     mkdir -p $out
  #     cp -r $src/neomuttrc $out/catppuccin-neomutt
  #   '';
  #   name = pname;
  #   pname = "catppuccin-neomutt";
  #   phases = "buildPhase";
  #   src = inputs.catppuccin-neomutt;
  # };
  cheat-sh = mkTmuxPlugin {
    pluginName = "cheat-sh";
    postInstall = ''
      sed -i -e "s|& cht\.sh|\& ${nixpkgs.cht-sh}/bin/cht.sh|g" $target/cheat.sh
    '';
    rtpFilePath = "cheat-sh.tmux";
    src = inputs.tmux-cheat-sh;
    version = "0.0.1";
  };
  conceal-nvim = buildVimPlugin {
    name = "conceal-nvim";
    src = inputs.conceal-nvim;
  };
  networkmanagerapplet = nixpkgs.networkmanagerapplet.override {
    libnma = nixpkgs.libnma-gtk4;
  };
  nvim-cmp-nerdfont = buildVimPlugin {
    name = "cmp-nerdfont";
    src = inputs.nvim-cmp-nerdfont;
  };
  nvim-undotree = buildVimPlugin {
    name = "undotree";
    src = inputs.nvim-undotree;
  };
  one-small-step-for-vimkind = buildVimPlugin {
    name = "one-small-step-for-vimkind";
    src = inputs.one-small-step-for-vimkind;
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
  sddm = nixpkgs.sddm.override {
    extraPackages = [
      nixpkgs.where-is-my-sddm-theme
    ];
    withWayland = true;
  };
  sessionx = tmux-sessionx.packages.default;
  switchssh = writeScriptBin "switchssh" ''
    #!${nixpkgs.expect}/bin/expect
    eval spawn -noecho ssh $argv
    interact {
      \177 { send "\010" }
      "\033\[3~" { send "\177" }
    }
  '';
  tmux-fzf-url = mkTmuxPlugin {
    pluginName = "tmux-fzf-url";
    rtpFilePath = "fzf-url.tmux";
    src = inputs.tmux-fzf-url;
    version = "0.0.47";
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
