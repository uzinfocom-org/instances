{outputs, ...}: {
  # imports = [outputs.nixosModules.nginx];

  # Enable web server & proxy
  services.www = {
    enable = false;
    alias = ["uz1.kolyma.uz"];
    no-default = true;
    hosts = {};
  };
}
