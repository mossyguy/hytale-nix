{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = { self, flake-parts, ...} @inputs: flake-parts.lib.mkFlake { inherit inputs; } {
    systems = [ "x86_64-linux" ];

    perSystem = { pkgs, lib, system, ... }: let
      version = "2026.06.24-5dbd7e9";
      sha256 = "sha256-qHGRkezRqrSOoq6xei+0AEWkzLY/O0P2OFvQG7SCPTw=";
      url = "https://launcher.hytale.com/builds/release/linux/amd64/hytale-launcher-${version}.zip";
      src = pkgs.fetchzip {
        inherit url sha256;
      };
    in {
      packages = rec {
        hytale-launcher-unwrapped = (pkgs.callPackage ./nix/hytale-launcher-unwrapped.nix {
          inherit version src;
        });
        hytale-launcher = (pkgs.callPackage ./nix/hytale-launcher.nix {
          inherit version hytale-launcher-unwrapped;
        });
      };
      apps.default = {
        type = "app";
        program = "${lib.getExe self.packages.${system}.hytale-launcher}";
      };
    };
  };
}

