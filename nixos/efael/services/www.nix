{outputs, ...}: {
  imports = [outputs.nixosModules.www];

  # Enable web server & proxy
  services.www = {
    enable = true;
    alias = ["ns1.efael.uz"];
    no-default = true;
    hosts = {};
  };
}
