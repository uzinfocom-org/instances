{
  config,
  outputs,
  ...
}:
let
  runner-sm = {
    owner = config.uzinfocom.runners.user;
    sopsFile = ../../../secrets/runners.yaml;
  };
in
{
  imports = [
    # Top level abstractions
    outputs.nixosModules.web
    outputs.nixosModules.matrix-py
    outputs.nixosModules.runner

    # Per app preconfigured abstractions
    outputs.nixosModules.apps.uchar-website
  ];

  sops = {
    secrets = {
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

      # Runners
      "forgejo/testing" = runner-sm;
      "github/testing/uzinfocom" = runner-sm;
      "github/testing/xinux" = runner-sm;
      "github/testing/uchar" = runner-sm;
      "github/testing/bleur" = runner-sm;
    };

    templates = {
      "gitea-forgejo-uzinfocom" = {
        owner = config.uzinfocom.runners.user;
        content = ''
          TOKEN=${config.sops.placeholder."forgejo/testing"}
        '';
      };
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

    # * -> git*.*
    runners = {
      enable = true;
      instances = [
        {
          name = "Default";
          type = "forgejo";
          label = "testing";
          url = "https://git.oss.uzinfocom.uz";
          token = config.sops.templates."gitea-forgejo-uzinfocom".path;
        }
        {
          name = "Uzinfocom";
          type = "github";
          label = "testing";
          url = "https://github.com/uzinfocom-org";
          token = config.sops.secrets."github/testing/uzinfocom".path;
        }
        {
          name = "Xinux";
          type = "github";
          label = "testing";
          url = "https://github.com/xinux-org";
          token = config.sops.secrets."github/testing/xinux".path;
        }
        {
          name = "Uchar";
          type = "github";
          label = "testing";
          url = "https://github.com/uchar-org";
          token = config.sops.secrets."github/testing/uchar".path;
        }
        {
          name = "Bleur";
          type = "github";
          label = "testing";
          url = "https://github.com/bleur-org";
          token = config.sops.secrets."github/testing/bleur".path;
        }
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
