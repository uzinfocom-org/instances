{...}: {
  # imports = [outputs.nixosModules.example];

  # Enable adguard home
  services.adguardhome = {
    enable = true;
    openFirewall = true;
  };
}
