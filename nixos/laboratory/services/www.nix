{outputs, ...}: {
  imports = [outputs.nixosModules.web];

  # Enable web server & proxy
  services.www = {
    enable = false;

    default = {
      enable = true;
      cert = false;
      domain = "laboratory.local";
    };
  };
}
