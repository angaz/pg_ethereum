# generated by zon2nix (https://github.com/nix-community/zon2nix)

{ linkFarm, fetchzip }:

linkFarm "zig-packages" [
  {
    name = "122038dcc6b7cf765674164beb19c0698af8eee71f150ee7e073086ced4d59ec4c2f";
    path = fetchzip {
      url = "https://github.com/angaz/zig-rlp/archive/da44f39e0670783afeecfe49c33a7a84af876f65.tar.gz";
      hash = "sha256-cTCIJ1YQSyxqTtGMctpmSptEQuYV9e2UgjMo+CQKOxI=";
    };
  }
]
