{
  description = "Postgres extension for Ethereum data-types written in Zig";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    zig.url = "github:mitchellh/zig-overlay";
    zls.url = "github:zigtools/zls";

    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };
    gitignore = {
      url = "github:hercules-ci/gitignore.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{
    self,
    nixpkgs,
    devshell,
    flake-parts,
    gitignore,
    ...
  }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        devshell.flakeModule
        flake-parts.flakeModules.easyOverlay
      ];

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem = { config, pkgs, system, ... }: let
        inherit (gitignore.lib) gitignoreSource;
        zig = inputs.zig.packages.${system};
        zls = inputs.zls.packages.${system}.zls;
      in {
        overlayAttrs = {
          inherit (config.packages)
            pg_ethereum;
        };

        packages = {
          pg_ethereum = pkgs.stdenv.mkDerivation {
            pname = "pg_ethereum";
            version = "0.0.1";

            src = gitignoreSource ./.;

            buildInputs = with pkgs; [
              libkrb5.dev
              openssl.dev
              postgresql_16
            ];
            nativeBuildInputs = [
              zig.master-2024-03-22
            ];

            buildPhase = ''
              mkdir -p .cache

              ln -s ${pkgs.callPackage ./deps.nix { }} $(pwd)/.cache/p

              zig build \
                --color off \
                --cache-dir $(pwd)/zig-cache \
                --global-cache-dir $(pwd)/.cache \
                --prefix $out
            '';
          };
        };

        devshells.default = {
          env = [
            {
              # Needed to be able to run `zig build` outside of the package build env
              name = "LD_LIBRARY_PATH";
              value = "LD_LIBRARY_PATH:${pkgs.libkrb5.dev}/include:${pkgs.openssl.dev}/include:${pkgs.postgresql_16}/include";
            }
          ];

          packages = with pkgs; [
            # run `direnv reload` to rebuild the package, and install it a local PG install
            (postgresql_16.withPackages (p: [self.packages.${system}.pg_ethereum]))

            # Fixes https://github.com/nix-community/zon2nix/pull/8
            (zon2nix.overrideAttrs (o: {
              patches = (o.patches or [] ++ [
                (pkgs.fetchpatch {
                  url = "https://patch-diff.githubusercontent.com/raw/nix-community/zon2nix/pull/8.patch";
                  hash = "sha256-uZrEdJKKmNfW+OVFWbcimLRUv8IDLQtYQ87zIorq3Zc=";
                })
              ]);
            }))

            # PGZX build dependencies
            libkrb5.dev
            openssl.dev

            zig.master-2024-03-22
            zls
          ];
        };
      };
    };
}
