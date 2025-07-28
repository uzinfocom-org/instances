{outputs, ...}: {
  imports = [outputs.nixosModules.container];

  # Enable containerization
  services.containers = {
    enable = true;
  };

  # Ensure the firewall allows HTTP and HTTPS traffic
  # networking.firewall.allowedTCPPorts = [];
  # networking.firewall.allowedUDPPorts = [];
}
