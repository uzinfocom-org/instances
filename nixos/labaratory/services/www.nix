{outputs, ...}: {
  imports = [outputs.nixosModules.web];

  # Enable web server & proxy
  services.www = {
    enable = true;
    alias = ["uz1.kolyma.uz"];
    no-default = true;
    hosts = {};
  };
}
