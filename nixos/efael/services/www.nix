{outputs, ...}: {
  imports = [outputs.nixosModules.web];

  # Enable web server & proxy
  services.www = {
    enable = true;

    default = {
      enable = true;
      domain = "ns1.efael.uz";
    };
  };
}
