{
  config,
  outputs,
  ...
}: {
  imports = [
    # Top level abstractions
    outputs.nixosModules.web
    outputs.nixosModules.mail
    outputs.nixosModules.auth
    outputs.nixosModules.matrix

    # Per app preconfigured abstractions
    outputs.nixosModules.apps.uchar-website
  ];

  sops.secrets = {
    # Matrix oriented secrets
    "matrix/server" = {
      format = "binary";
      owner = "matrix-synapse";
      sopsFile = ../../../secrets/berk/matrix/server-2.hell;
    };
    "matrix/authentication" = {
      format = "binary";
      owner = "matrix-authentication-service";
      sopsFile = ../../../secrets/berk/matrix/authentication-2.hell;
    };
  };

  # https://ns1.uzberk.uz
  uzinfocom = {
    www = {
      enable = true;
      domain = "ns3.uzberk.uz";
    };

    # https://(chat|matrix).mg.uzberk.uz
    matrix = {
      enable = true;
      domain = "mg.uzberk.uz";
      cap = true;

      synapse.extra-config-files = [
        config.sops.secrets."matrix/server".path
      ];

      matrix-authentication-service.extra-config-files = [
        config.sops.secrets."matrix/authentication".path
      ];
    };

    # *://*
    apps = {
      # https://mg.berk.uz
      uchar.website = {
        enable = true;
        domain = "mg.uzberk.uz";
      };
    };
  };
}
