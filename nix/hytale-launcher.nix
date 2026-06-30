{
  buildFHSEnv,
  stdenv,
  lib,
  version,
  writeShellScript,
  hytale-launcher-unwrapped,
  makeDesktopItem,
  webkitgtk_4_1,
  gtk3,
  glib,
  gdk-pixbuf,
  libsoup_3,
  cairo,
  pango,
  at-spi2-atk,
  harfbuzz,
  libGL,
  libGLU,
  libglvnd,
  mesa,
  vulkan-loader,
  egl-wayland,
  libX11,
  libXcomposite,
  libXdamage,
  libXext,
  libXfixes,
  libXrandr,
  libXcursor,
  libXi,
  libxcb,
  libXScrnSaver,
  libXinerama,
  libXxf86vm,
  wayland,
  libxkbcommon,
  alsa-lib,
  pipewire,
  pulseaudio,
  dbus,
  fontconfig,
  freetype,
  glibc,
  nspr,
  nss,
  systemd,
  zlib,
  icu,
  openssl,
  krb5,
  glib-networking,
  cacert,
}: buildFHSEnv {
  name = "hytale-launcher";
  inherit version;

  targetPkgs = pkgs: [
    hytale-launcher-unwrapped
    webkitgtk_4_1
    gtk3
    glib
    gdk-pixbuf
    libsoup_3
    cairo
    pango
    at-spi2-atk
    harfbuzz
    libGL
    libGLU
    libglvnd
    mesa
    vulkan-loader
    egl-wayland
    libX11
    libXcomposite
    libXdamage
    libXext
    libXfixes
    libXrandr
    libXcursor
    libXi
    libxcb
    libXScrnSaver
    libXinerama
    libXxf86vm
    wayland
    libxkbcommon
    alsa-lib
    pipewire
    pulseaudio
    dbus
    fontconfig
    freetype
    glibc
    nspr
    nss
    systemd
    zlib
    stdenv.cc.cc.lib
    icu
    openssl
    krb5
    glib-networking
    cacert
  ];

  runScript = writeShellScript "hytale-launcher-wrapper" ''
    LAUNCHER_DIR="''${XDG_DATA_HOME:-$HOME/.local/share}/Hytale"
    LAUNCHER_BIN="$LAUNCHER_DIR/hytale-launcher"
    BUNDLED_HASH_FILE="$LAUNCHER_DIR/.bundled_hash"
    BUNDLED_BIN="${hytale-launcher-unwrapped}/lib/hytale-launcher/hytale-launcher"

    mkdir -p "$LAUNCHER_DIR"

    BUNDLED_HASH=$(sha256sum "$BUNDLED_BIN" | cut -d" " -f1)

    if [ ! -x "$LAUNCHER_BIN" ] || [ ! -f "$BUNDLED_HASH_FILE" ] || [ "$(cat "$BUNDLED_HASH_FILE")" != "$BUNDLED_HASH" ]; then
      install -m755 "$BUNDLED_BIN" "$LAUNCHER_BIN"
      echo "$BUNDLED_HASH" > "$BUNDLED_HASH_FILE"
    fi

    export WEBKIT_DISABLE_COMPOSITING_MODE=1
    export __NV_DISABLE_EXPLICIT_SYNC=1
    export WEBKIT_DISABLE_DMABUF_RENDERER=1
    export GIO_MODULE_DIR=/usr/lib/gio/modules
    export SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt

    exec "$LAUNCHER_BIN" "$@"
  '';

  extraInstallCommands = ''
    mkdir -p $out/share/applications
    cp ${makeDesktopItem {
      name = "hytale-launcher";
      desktopName = "Hytale Launcher";
      comment = "Official launcher for Hytale";
      icon = "hytale-launcher";
      terminal = false;
      type = "Application";
      categories = [ "Game" ];
      keywords = [ "hytale" "game" "launcher" "hypixel" ];
      startupWMClass = "com.hypixel.HytaleLauncher";
      exec = "hytale-launcher";
    }}/share/applications/* $out/share/applications/
  '';

  meta = with lib; {
    description = "Official launcher for Hytale game";
    longDescription = ''
      The official launcher for Hytale, developed by Hypixel Studios.
      This package wraps the launcher from the official distribution,
      providing FHS compatibility for self-updates.
    '';
    homepage = "https://hytale.com";
    license = licenses.unfree;
    sourceProvenance = sourceTypes.binaryNativeCode;
    platforms = [ "x86_64-linux" ];
    mainProgram = "hytale-launcher";
  };
}
