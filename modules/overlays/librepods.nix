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
      ]}
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
