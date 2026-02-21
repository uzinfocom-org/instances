{
  config,
  outputs,
  ...
}:
{
  imports = [
    # Top level abstractions
    outputs.nixosModules.web
    outputs.nixosModules.hydra
  ];

  # Uzinfocom Services
  uzinfocom = {
    # https://ns1.xinux.uz
    www = {
      enable = true;
      domain = "ns1.xinux.uz";
    };

    # https://(hydra|cache).xinux.uz
    hydra.enable = true;
    nixpkgs.master = true;
  };
}
