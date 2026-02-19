{
  config,
  outputs,
  ...
}:
{
  imports = [
    # Top level abstractions
    outputs.nixosModules.web
  ];

  # https://ns2.uchar.uz
  uzinfocom = {
    www = {
      enable = true;
      domain = "ns1.xinux.uz";
    };
  };
}
