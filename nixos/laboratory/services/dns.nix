{...}: {
  # imports = [outputs.nixosModules.example];

  # Enable adguard home
  services.adguardhome = {
    enable = true;
    openFirewall = true;
  };

  networking.firewall.allowedTCPPorts = [53];
  networking.firewall.allowedUDPPorts = [53];
}
