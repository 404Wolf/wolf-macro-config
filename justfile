default:
    @just --list

# Initial install via nixos-anywhere (run from host after VM is booted from NixOS ISO with sshd up)
install:
    nix run github:nix-community/nixos-anywhere -- \
        --flake .#wolf-vm \
        --ssh-port 2224 \
        root@localhost

# Rebuild and switch the VM (run from inside the VM)
switch:
    sudo nixos-rebuild switch --flake .#wolf-vm

# Build on the host and push the result to the VM (run from the host)
push_switch:
    NIX_SSHOPTS="-p 2224" nixos-rebuild switch --flake .#wolf-vm \
        --target-host wolf@localhost \
        --use-remote-sudo

# Update flake inputs
update:
    nix flake update

# SSH into the VM (run from the host)
ssh:
    ssh -p 2224 wolf@localhost
