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
      version = "2026.06.24-5012345";
      sha256 = "sha256-gEwcRoEz4Td6WaI2tZG1UsJzRCcBJCJf1J0Eeg4Uwgk=";
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
