{
  description = "NixOS configuration for wolf-vm";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, disko, nix-index-database, ... }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };

    mkHost = { name, extraModules ? [] }: nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        disko.nixosModules.disko
        nix-index-database.nixosModules.nix-index
        ./config/config.nix
        ./config/nix.nix
        ./config/network.nix
        ./config/hosts/${name}
      ] ++ extraModules;
    };
  in {
    nixosConfigurations.wolf-vm = mkHost { name = "wolf-vm"; };

    nixosConfigurations.wolf-macro-google = mkHost { name = "wolf-macro-google"; };

    devShells.${system}.default = pkgs.mkShell {
      packages = [ pkgs.just ];
    };
  };
}
