{
  nix.settings = {
    auto-optimise-store = true;
    substituters = [
      "http://10.0.2.2:5000"
      "https://hyprland.cachix.org"
      "https://zed.cachix.org"
      "https://cache.garnix.io"
    ];
    trusted-public-keys = [
      "server-cache-1:Fn4+Xw2tnz9aosyhqOQ5vFbEC8oW1g3E+3EyaHDKyt4="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "zed.cachix.org-1:/pHQ6dpMsAZk2DiP4WCL0p9YDNKWj2Q5FL20bNmw1cU="
    ];
    trusted-users = [ "root" "wolf" ];
    experimental-features = [ "nix-command" "flakes" ];
  };
}
