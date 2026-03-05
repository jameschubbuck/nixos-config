final: prev: let
  lib = prev.lib;
in {
  librepods = prev.rustPlatform.buildRustPackage {
    pname = "librepods";
    version = "0.2.0-linux-rust";

    src = prev.fetchFromGitHub {
      owner = "kavishdevar";
      repo = "librepods";
      rev = "4737cbfc2c1a4e227e42d095c49ab43bd8d7b64a";
      hash = "sha256-5vPCtjUiFSI/Ix5dbGmR3TGQsYIwWAUHMwx8yH6HXac=";
    };

    sourceRoot = "source/linux-rust";
    cargoHash = "sha256-Ebqx+UU2tdygvqvDGjBSxbkmPnkR47/yL3sCVWo54CU=";

    nativeBuildInputs = with prev; [
      pkg-config
      makeWrapper
    ];

    buildInputs = with prev; [
      libpulseaudio
      dbus
      vulkan-loader
      libGL
      wayland
      libxkbcommon
      xorg.libXcursor
      xorg.libXrandr
      xorg.libXi
      xorg.libX11

      # Qt/QML runtime so QML modules (like kvantum) can be found at runtime
      qt6.qtbase
      qt6.qtdeclarative
      qt6.qtquickcontrols2

      # Also include Qt5 fallbacks in case the upstream QML expects Qt5 modules
      qt5.qtbase
      qt5.qtdeclarative
      qt5.qtquickcontrols2

      # Theme / QML module used by the upstream QML (may be kvantum or kvantum-qt5
      # depending on your nixpkgs). Keep the common name here.
      # Kvantum style packages (multiple attrs exist across nixpkgs)
      kdePackages.qtstyleplugin-kvantum
      libsForQt5.qtstyleplugin-kvantum

      # Optional helper referenced by the runtime
      pavucontrol
    ];

    postFixup = ''
      wrapProgram $out/bin/librepods \
        --suffix LD_LIBRARY_PATH : ${lib.makeLibraryPath [
          prev.libpulseaudio
          prev.dbus
          prev.vulkan-loader
          prev.libGL
          prev.wayland
          prev.libxkbcommon
          prev.xorg.libXcursor
          prev.xorg.libXrandr
          prev.xorg.libXi
          prev.xorg.libX11
          prev.qt6.qtbase
          prev.qt6.qtdeclarative
        ]} \
        --set QML2_IMPORT_PATH "${prev.kdePackages.qtstyleplugin-kvantum}/lib/qt6/qml:${prev.kdePackages.qtstyleplugin-kvantum}/lib/qt5/qml:${prev.libsForQt5.qtstyleplugin-kvantum}/lib/qt5/qml:${prev.qt6.qtdeclarative}/lib/qt6/qml:${prev.qt5.qtdeclarative}/lib/qt5/qml:${prev.qt6.qtbase}/lib/qt6/qml:${prev.qt5.qtbase}/lib/qt5/qml" \
        --set XDG_DATA_DIRS "${prev.kdePackages.qtstyleplugin-kvantum}/share:${prev.libsForQt5.qtstyleplugin-kvantum}/share:${prev.qt6.qtbase}/share:${prev.qt5.qtbase}/share:$XDG_DATA_DIRS" \
        --set QT_PLUGIN_PATH "${prev.qt6.qtbase}/lib/qt6/plugins:${prev.qt5.qtbase}/lib/qt5/plugins:$QT_PLUGIN_PATH" \
        --set PATH "${prev.pavucontrol}/bin:$PATH"
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
