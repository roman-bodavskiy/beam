{
  inputs = {
    common.url = "github:nammayatri/common?ref=ghc-98-upgrade";
    nixpkgs.follows = "common/nixpkgs";
    flake-parts.follows = "common/flake-parts";
    haskell-flake.follows = "common/haskell-flake";
  };

  outputs = inputs@{ self, nixpkgs, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } ({ withSystem, ... }: {
      systems = nixpkgs.lib.systems.flakeExposed;
      imports = [
        inputs.common.flakeModules.ghc98
        inputs.haskell-flake.flakeModule
      ];
      perSystem = { self', pkgs, lib, config, ... }: {
        haskellProjects.default = {
          projectFlakeName = "beam";
          basePackages = config.haskellProjects.ghc98.outputs.finalPackages;
          autoWire = ["packages" "checks" "devShells" "apps"];
          settings = {
            pretty-simple = {
              check = false;
            };
            sandwich = {
              check = false;
            };
          };
        };
      };
    });
}  
