# Fallback validation point of all modules
{ outputs, ... }:
{
  # List all modules here to be included on config
  imports = [
    # Web server & proxy virtual hosts via nginx
    outputs.nixosModules.web

    # Matrix livekit hosting
    outputs.nixosModules.matrix-live
  ];

  # Enable web server & proxy
  uzinfocom = {
    www = {
      enable = true;
      domain = "ns2.uzberk.uz";
    };

    # https://(livekit(-jwt)|call).uzberk.uz
    matrix-live = {
      enable = true;
      homeserver = "uchar.uz";
    };
  };
}
