{...}: {
  # imports = [outputs.nixosModules.nginx];

  # Enable web server & proxy
  services.www = {
    enable = false;
    alias = [];
    no-default = true;
    hosts = {};
  };
}
