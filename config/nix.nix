{
  nix.settings = {
    auto-optimise-store = true;
    substituters = [
      "https://hyprland.cachix.org"
      "https://zed.cachix.org"
    ];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "zed.cachix.org-1:/pHQ6dpMsAZk2DiP4WCL0p9YDNKWj2Q5FL20bNmw1cU="
    ];
    trusted-users = [ "root" "wolf" ];
    experimental-features = [ "nix-command" "flakes" ];
  };
}
