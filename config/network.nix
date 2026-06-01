{
  services.tailscale.enable = true;

  services.resolved = {
    enable = true;
    settings.Resolve.DNSStubListener = "yes";
  };
}
