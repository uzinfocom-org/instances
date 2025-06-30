{outputs, ...}: {
  imports = [outputs.nixosModules.web];

  # Enable web server & proxyi
  services.www = {
    enable = true;
    alias = ["ns1.efael.uz"];
    no-default = true;
    hosts = {};
  };
}
