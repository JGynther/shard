{
    description = "Shard build environment";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs";
    };

    outputs = { self, nixpkgs }:
      let
          supportedSystems = [
              "x86_64-linux"      # 64-bit Intel/AMD Linux
              "aarch64-linux"     # 64-bit ARM Linux
              "x86_64-darwin"     # 64-bit Intel macOS
              "aarch64-darwin"    # 64-bit ARM macOS
          ];

          forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
            pkgs = import nixpkgs { inherit system; };
          });
      in
      {
          devShells = forEachSupportedSystem ({ pkgs }: {
              default = pkgs.mkShell
              {
                  packages = with pkgs; [
                      clang-tools
                      ninja
                      
                      # Dependencies
                      raylib
                      luajit
                  ];
              };
          });
      };
}