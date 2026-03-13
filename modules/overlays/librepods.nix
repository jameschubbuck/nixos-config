final: prev: let
  lib = prev.lib;
in {
  librepods = prev.stdenv.mkDerivation {
    pname = "librepods";
    version = "0.2.0-linux";

    src = prev.fetchFromGitHub {
      owner = "kavishdevar";
      repo = "librepods";
      rev = "fd33528218b7e1378429c4d773d757e4be36416f";
      hash = "sha256-NhoWMx9M9X2pHMYZCre6We80jl8XV6843J5y37v9Hyg=";
    };

    sourceRoot = "source/linux";

    nativeBuildInputs = with prev; [
      cmake
      pkg-config
      makeWrapper
      qt6.wrapQtAppsHook
      qt6.qttools
    ];

    buildInputs = with prev; [
      libpulseaudio
      dbus
      openssl
      qt6.qtbase
      qt6.qtdeclarative
      qt6.qtconnectivity
      qt6.qtmultimedia
      pavucontrol
    ];

    postFixup = ''
      wrapProgram $out/bin/librepods \
        --set PATH "${prev.pavucontrol}/bin:$PATH" \
        --set QT_STYLE_OVERRIDE "Fusion"
    '';

    meta = {
      description = "AirPods liberated from Apple's ecosystem";
      homepage = "https://github.com/kavishdevar/librepods";
      mainProgram = "librepods";
      license = lib.licenses.gpl3;
      platforms = lib.platforms.linux;
    };
  };
}
