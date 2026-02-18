{
  config,
  outputs,
  ...
}:
{
  imports = [
    # Top level abstractions
    outputs.nixosModules.web
    # outputs.nixosModules.mail
    # outputs.nixosModules.matrix
    # outputs.nixosModules.matrix-live

    # Per app preconfigured abstractions
    # outputs.nixosModules.apps.uchar-website
  ];

  # sops.secrets = {
  #   # Mail oriented services
  #   "mail/hashed" = {
  #     key = "mail/hashed";
  #     sopsFile = ../../../secrets/uchar/mail.yaml;
  #   };

  #   # Matrix oriented secrets
  #   "matrix/server" = {
  #     format = "binary";
  #     owner = "matrix-synapse";
  #     sopsFile = ../../../secrets/uchar/matrix/server.hell;
  #   };
  #   "matrix/authentication" = {
  #     format = "binary";
  #     owner = "matrix-authentication-service";
  #     sopsFile = ../../../secrets/uchar/matrix/authentication.hell;
  #   };
  #   "matrix/push" = {
  #     format = "binary";
  #     owner = "matrix-sygnal";
  #     path = "/var/lib/matrix-sygnal/sygnal.yaml";
  #     sopsFile = ../../../secrets/uchar/matrix/push.hell;
  #   };
  #   "matrix/ident" = {
  #     format = "binary";
  #     owner = "matrix-sygnal";
  #     path = "/var/lib/matrix-sygnal/service_account.json";
  #     sopsFile = ../../../secrets/uchar/matrix/saccount.hell;
  #   };
  # };

  # https://ns1.uchar.uz
  uzinfocom = {
    www = {
      enable = true;
      domain = "ns1.uchar.uz";
    };
  };
}
