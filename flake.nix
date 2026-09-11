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
          pythonDist
        ];
        name = "dataload_test";
      in
      {
        devShell = pkgs.mkShell {
          packages = packages;
        };
        packages.default = pkgs.${pythonPacks}.buildPythonApplication {
          pname = name;
          version = "0.1.0";
          src = ./src;
          pyproject = true;
          build-system = [ pkgs.${pythonPacks}.setuptools ];

          propagatedBuildInputs = pythonDeps pkgs.${pythonPacks};
          postInstall = ''
            cp $out/bin/run.py $out/bin/dataload_test
          '';
        };
        packages.dockerImage = pkgs.dockerTools.buildImage {
          inherit name;
          config = {
            Cmd = [ "${pkgs.fastapi-cli} dev" ];
          };
        };
      }
    );
}
