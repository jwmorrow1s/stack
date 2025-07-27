{
  description = "guile playground";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };
  outputs = { self, nixpkgs }: let 
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
  in {
    packages.${system} = pkgs.stdenv.mkDerivation {
      default = pkgs.stdenv.mkDerivation {
        name = "main"; 
        src = ./.;
        buildInputs = [
          pkgs.guile_3_0
          pkgs.gnumake
        ];
        buildPhase = ''
          echo "TODO"
          exit 1
        '';
        installPhase = ''
          echo "TODO"
          exit 1
        '';
      };
    };
    devShell.${system} = pkgs.mkShell { buildInputs = [pkgs.guile_3_0 pkgs.guile pkgs.pkg-config]; };
  };
}
