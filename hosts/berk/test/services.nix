{
  config,
  outputs,
  ...
}:
{
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
      sopsFile = ../../../secrets/berk/matrix/server-x.hell;
    };
    "matrix/authentication" = {
      format = "binary";
      owner = "matrix-authentication-service";
      sopsFile = ../../../secrets/berk/matrix/authentication-x.hell;
    };
  };

  uzinfocom = {
    # https://nsx.uzberk.uz
    www = {
      enable = true;
      domain = "nsx.uzberk.uz";
    };

    # https://(chat|matrix).mg.uzberk.uz
    matrix = {
      enable = true;
      domain = "plazma.uzberk.uz";
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
      # https://plazma.berk.uz
      uchar.website = {
        enable = true;
        domain = "plazma.uzberk.uz";
      };
    };
  };
}
