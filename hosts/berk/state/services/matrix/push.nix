{inputs, ...}: {
  imports = [
    inputs.sygnal.nixosModules.server
  ];

  services.matrix-sygnal = {
    enable = true;
    configFile = "/var/lib/matrix-sygnal/push.yaml";
  };
}
