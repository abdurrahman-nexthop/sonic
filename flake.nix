{
  description = "SONIC development flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        jinjanator-plugins = pkgs.python3Packages.callPackage ./jinjanator-plugins.nix { };
        jinjanator = pkgs.python3Packages.callPackage ./jinjanator.nix { inherit jinjanator-plugins; };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            awscli2
            gnumake
            jinjanator
            python3
            wget
          ];

          shellHook = ''
            echo "SONIC build environment for ${system}"
            export SONIC_BUILD_JOBS=$NIX_BUILD_CORES
            export BUILD_SKIP_TEST=y
          '';
        };
      }
    );
}
