{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    {
      overlay = final: prev: {
        em0lar-dev-website = with final; stdenv.mkDerivation {
          name = "em0lar-dev-website";
          src = self;
          buildInputs = [ hugo ];
          buildPhase = "hugo --minify -d $out";
          dontInstall = true;
        };
      };
    } // (
      flake-utils.lib.eachDefaultSystem (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlay ];
          };
        in {
          packages.em0lar-dev-website = pkgs.em0lar-dev-website;
          defaultPackage = pkgs.em0lar-dev-website;
          devShell = pkgs.mkShell {
            packages = with pkgs; [
              hugo
            ];
          };
        }
      )
    );
}
