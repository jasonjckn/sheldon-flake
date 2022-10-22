{
  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    sheldon-src = {
      url = "github:rossmacarthur/sheldon";
      flake = false;
    };

  };

  outputs = inputs@{self, nixpkgs, flake-utils, sheldon-src, ...}:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        {
          defaultPackage = self.packages.${system}.sheldon;

          packages.sheldon = pkgs.rustPlatform.buildRustPackage {
            name = "sheldon";
            src = "${sheldon-src}";
            cargoLock.lockFile = "${sheldon-src}/Cargo.lock";
            nativeBuildInputs = with pkgs; [ pkg-config ];
            buildInputs = with pkgs; [ openssl ];
            checkPhase = "true";
          };
        });
}
