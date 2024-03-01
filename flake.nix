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
              postgresql_16
              pkg-config
            ];
            nativeBuildInputs = [
              zig.master-2024-02-23
            ];

            buildPhase = ''
              mkdir -p .cache

              zig build \
                --color off \
                --cache-dir $(pwd)/zig-cache \
                --global-cache-dir $(pwd)/.cache \
                --prefix $out
            '';

            installPhase = ''
              mkdir -p $out/share/postgresql/extension

              mv $out/lib/libpg_ethereum.so $out/lib/pg_ethereum.so
              cp extension/*                $out/share/postgresql/extension/
            '';
          };
        };

        devshells.default = {
          commands = [
          ];

          packages = with pkgs; [
            (postgresql_16.withPackages (p: [self.packages.${system}.pg_ethereum]))
            clang-tools  # For clangd lsp
            zon2nix

            zig.master-2024-02-23
            zls
          ];
        };
      };
    };
}
