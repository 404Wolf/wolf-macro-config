default:
    @just --list

# Initial install via nixos-anywhere (run from host after VM is booted from NixOS ISO with sshd up)
install-vm:
    nix run github:nix-community/nixos-anywhere -- \
        --flake .#wolf-vm \
        --ssh-port 2224 \
        root@localhost

# Initial install via nixos-anywhere onto a live Debian box (kexec-based, WIPES its disks).
# Must target the public IP, not the tailscale hostname: the kexec'd installer
# environment has no tailscale running, so the overlay address is unreachable
# once it reboots into the installer.
install-google ip:
    nix run github:nix-community/nixos-anywhere -- \
        --flake .#wolf-macro-google \
        --target-host wolf@{{ip}}

# Rebuild and switch the local VM (run from inside the VM)
switch-local:
    sudo nixos-rebuild switch --flake .#wolf-vm

# Rebuild and switch wolf-macro-google (run from the host, over tailscale)
switch-google:
    NIX_SSHOPTS="-p 22" nixos-rebuild switch --flake .#wolf-macro-google \
        --target-host wolf@wolf-macro-google \
        --use-remote-sudo

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
