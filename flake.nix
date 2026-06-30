{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    utils,
    self,
    ...
  }: utils.lib.eachSystem [ "x86_64-linux" ] (system: let
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      version = "2026.06.24-5dbd7e9";
      sha256 = "sha256-XBmIBdA65iv7WWa6C/K3pU6wRKkEMUGe9MFPXjqz3nk=";
    in {
      packages = rec {
        hytale-launcher-unwrapped = (pkgs.callPackage ./nix/hytale-launcher-unwrapped.nix {
          inherit version;
        });
        hytale-launcher = (pkgs.callPackage ./nix/hytale-launcher.nix {
          inherit version hytale-launcher-unwrapped;
        });
      };
      apps.default = {
        type = "app";
        program = "${with pkgs; lib.getExe self.packages.${system}.hytale-launcher}";
      };
  });
}
