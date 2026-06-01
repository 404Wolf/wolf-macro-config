{
  description = "NixOS configuration for wolf-vm";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, disko, ... }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in {
    nixosConfigurations.wolf-vm = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        disko.nixosModules.disko
        ./config/disk.nix
        ./config/config.nix
        ./config/virt.nix
        ./config/nix.nix
        ./config/network.nix
      ];
    };

    devShells.${system}.default = pkgs.mkShell {
      packages = [ pkgs.just ];
    };
  };
}
