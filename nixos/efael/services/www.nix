{outputs, ...}: {
  imports = [outputs.nixosModules.web];

  # Enable web server & proxy
  services.www = {
    enable = true;
    alias = ["ns1.efael.uz"];
    no-default = true;
    hosts = {};
  };
}
