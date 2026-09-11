{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
        pkgs = import nixpkgs {
          inherit system;
        };
        pythonVer = "python314";
        pythonPacks = pythonVer + "Packages";
        pythonDeps = (
          python-pkgs: with python-pkgs; [
            sqlmodel
            fastapi
            uvicorn
          ]
        );
        pythonDist = pkgs.${pythonVer}.withPackages pythonDeps;
        packages = with pkgs; [
          fastapi-cli
          arion
          pythonDist
        ];
        name = "dataload_test";
      in
      {
        devShell = pkgs.mkShell {
          packages = packages;
        };
        packages.default = pkgs.callPackage ./package.nix { };
        packages.dockerImage = pkgs.dockerTools.buildImage {
          inherit name;
          tag = "latest";
          config = {
            Cmd = [ "${self.packages.x86_64-linux.default}/bin/dataload_test" ];
          };
        };
      }
    );
}
