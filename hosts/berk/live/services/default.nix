# Fallback validation point of all modules
{outputs, ...}: {
  # List all modules here to be included on config
  imports = [
    # Web server & proxy virtual hosts via nginx
    outputs.nixosModules.web

    # Matrix server hosting
    # ./matrix
  ];

  # Enable web server & proxy
  uzinfocom.www = {
    enable = true;
    domain = "ns2.uzberk.uz";
  };
}
