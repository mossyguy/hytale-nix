{
  stdenv,
  lib,
  version,
  src,  
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
  unzip
}: stdenv.mkDerivation {
  pname = "hytale-launcher-unwrapped";
  inherit version src;

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
