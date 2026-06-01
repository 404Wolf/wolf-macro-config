{ pkgs, ... }: {
  virtualisation = {
    docker.enable = true;
    podman.enable = true;
    oci-containers.backend = "podman";
  };

  environment.systemPackages = with pkgs; [
    docker-compose
    podman-compose
  ];

  users.users.wolf.extraGroups = [ "docker" "podman" ];
}
