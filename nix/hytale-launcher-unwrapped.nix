{
  stdenv,
  lib,
  version,
  sha256,  
  autoPatchelfHook,
  webkitgtk_4_1,
  gtk3,
  glib,
  gdk-pixbuf,
  libsoup_3,
  cairo,
  pango,
  at-spi2-atk,
  harfbuzz,
  glibc,
  libX11,
  libXcomposite,
  libXdamage,
  libXext,
  libXfixes,
  libXrandr,
  unzip,
  fetchurl
}: stdenv.mkDerivation {
  pname = "hytale-launcher-unwrapped";
  inherit version;      
  src = fetchurl {
    inherit sha256;
    url = "https://launcher.hytale.com/builds/release/linux/amd64/hytale-launcher-${version}.zip";
  };

  nativeBuildInputs = [ autoPatchelfHook unzip ];

  buildInputs = [
    webkitgtk_4_1
    gtk3
    glib
    gdk-pixbuf
    libsoup_3
    cairo
    pango
    at-spi2-atk
    harfbuzz
    glibc
  ];

  runtimeDependencies = [
    libX11
    libXcomposite
    libXdamage
    libXext
    libXfixes
    libXrandr
  ];

  dontUnpack = false;
  #unpackPhase = ''
  #  runHook preUnpack
  #  unzip $src -d .
  #  runHook postUnpack
  #'';
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/lib/hytale-launcher
    install -m755 hytale-launcher $out/lib/hytale-launcher/
  '';

  meta = with lib; {
    description = "Official launcher for Hytale game (unwrapped)";
    homepage = "https://hytale.com";
    license = [ licenses.unfree ];
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
  };
}
