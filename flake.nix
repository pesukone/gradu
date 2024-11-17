{
  description = "Flake for thesis related things";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};

      in rec {
        packages.gradu = pkgs.stdenv.mkDerivation {
          name = "gradu";
          src = self;

          dontPatch = true;
          dontConfigure = true;

          buildPhase = ''
            ${pkgs.texliveFull}/bin/latexmk -pdf HY-CS-main.tex
          '';

          installPhase = ''
            cp HY-CS-main.pdf $out
          '';
        };

        packages.view-gradu = pkgs.writeShellScriptBin "view-gradu" ''
          ${pkgs.texliveFull}/bin/latexmk -pvc -pdf HY-CS-main.tex
        '';

        packages.default = packages.view-gradu;
      }
    );
}
