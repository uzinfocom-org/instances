{
  config,
  outputs,
  ...
}:
{
  imports = [
    # Top level abstractions
    outputs.nixosModules.web
    # outputs.nixosModules.matrix-py
    # outputs.nixosModules.matrix-live
  ];

  sops.secrets = {
    # Matrix oriented secrets
    # "matrix/server" = {
    #   format = "binary";
    #   owner = "matrix-synapse";
    #   sopsFile = ../../../secrets/uportal/matrix/server.hell;
    # };
  };

  # Uzinfocom Services
  uzinfocom = {
    # https://*
    www.enable = true;

    # https://(matrix).berk.uz
    # matrix = {
    #   enable = false;

    #   # Root domain we are integrating to
    #   domain = "uzinfocom.uz";

    #   # We are integrating to ldap
    #   auth = "ldap";

    #   # We don't need web client, main product is client
    #   client = false;

    #   # Yup, we are using our own livekit
    #   call = "self-hosted";

    #   # We don't have access to root domain
    #   delegate = false;

    #   synapse.extra-config-files = [
    #     config.sops.secrets."matrix/server".path
    #   ];
    # };

    # https://(livekit(-jwt)|call).uchar.uz
    # matrix-live = {
    #   enable = false;
    #   homeserver = "uzinfocom.uz";
    # };
  };
}
