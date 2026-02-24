{
  config,
  outputs,
  ...
}:
{
  imports = [
    # Top level abstractions
    outputs.nixosModules.web
    outputs.nixosModules.bind
    # outputs.nixosModules.hydra
  ];

  # Uzinfocom Services
  uzinfocom = {
    # https://ns2.oss.uzinfocom.uz
    www = {
      enable = true;
      domain = "ns2.oss.uzinfocom.uz";
    };

    # bind://ns2.oss.uzinfocom.uz
    nameserver = {
      enable = true;
      type = "slave";
    };

    # https://(hydra|cache).xinux.uz
    # hydra.enable = true;
    # nixpkgs.master = true;
  };
}
