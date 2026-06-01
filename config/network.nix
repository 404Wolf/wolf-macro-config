{ lib, ... }: {
  services.tailscale.enable = true;

  services.resolved = {
    enable = true;
    settings.Resolve.DNSStubListener = "yes";
  };

  # Allow the kernel to route packets destined for 127.x.x.x from external interfaces,
  # then DNAT all incoming TCP/UDP to localhost so services bound to 127.0.0.1 are
  # reachable on all interfaces (e.g. wrangler dev, vite, etc.)
  boot.kernel.sysctl."net.ipv4.conf.all.route_localnet" = 1;
  networking.firewall.extraCommands = lib.mkAfter ''
    iptables -t nat -A PREROUTING -p tcp -j DNAT --to-destination 127.0.0.1
    iptables -t nat -A PREROUTING -p udp -j DNAT --to-destination 127.0.0.1
  '';
  networking.firewall.extraStopCommands = lib.mkAfter ''
    iptables -t nat -D PREROUTING -p tcp -j DNAT --to-destination 127.0.0.1 || true
    iptables -t nat -D PREROUTING -p udp -j DNAT --to-destination 127.0.0.1 || true
  '';
}
