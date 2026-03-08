{
  config,
  outputs,
  ...
}:
{
  imports = [
    # Top level abstractions
    outputs.nixosModules.web
    outputs.nixosModules.matrix-py

    # Per app preconfigured abstractions
    outputs.nixosModules.apps.uchar-website
  ];

  sops.secrets = {
    # Matrix oriented secrets
    "matrix/server" = {
      format = "binary";
      owner = "matrix-synapse";
      sopsFile = ../../../secrets/uchar/matrix-next/server.hell;
    };
    "matrix/authentication" = {
      format = "binary";
      owner = "matrix-authentication-service";
      sopsFile = ../../../secrets/uchar/matrix-next/authentication.hell;
    };
  };

  # Uzinfocom Services
  uzinfocom = {
    # https://ns3.oss.uzinfocom.uz
    www = {
      enable = true;
      domain = "ns3.oss.uzinfocom.uz";
    };

    # https://(chat|matrix).next.uchar.uz
    matrix = {
      enable = true;

      # Domain we are integrating to
      domain = "next.uchar.uz";

      # We are using our own livekit
      call = "self-hosted";

      # Our pre-deployed livekit is located at:
      call-domain = "uchar.uz";

      synapse.extra-config-files = [
        config.sops.secrets."matrix/server".path
      ];

      matrix-authentication-service.extra-config-files = [
        config.sops.secrets."matrix/authentication".path
      ];
    };

    # *://*
    apps = {
      # https://next.uchar.uz
      uchar.website = {
        enable = true;
        domain = "next.uchar.uz";
      };
    };
  };
}
