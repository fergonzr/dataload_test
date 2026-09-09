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
        packages = with pkgs; [
          fastapi-cli
          (python314.withPackages (
            python-pkgs: with python-pkgs; [
              sqlmodel
              fastapi
            ]
          ))
        ];
      in
      {
        devShell = pkgs.mkShell {
          packages = packages;
        };
      }
    );
}
