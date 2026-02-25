{
  config,
  outputs,
  ...
}:
{
  imports = [
    # Top level abstractions
    outputs.nixosModules.web
    outputs.nixosModules.git
    outputs.nixosModules.bind
    outputs.nixosModules.hydra
  ];

  sops.secrets = {
    "git/database" = {
      sopsFile = ../../../secrets/git/secrets.yaml;
      key = "database";
    };
    "git/mail" = {
      sopsFile = ../../../secrets/mail.yaml;
      key = "mail/raw";
    };
    "git/key" = {
      format = "binary";
      sopsFile = ../../../secrets/git/key.hell;
      path = "/etc/forgejo/ssh/id_forgejo";
    };
  };

  # Uzinfocom Services
  uzinfocom = {
    # https://ns2.oss.uzinfocom.uz
    www = {
      enable = true;
      domain = "ns2.oss.uzinfocom.uz";
      cdn = {
        "cdn.xinux.uz" = {
          path = "/srv/xinux";
          mode = "browse";
          extra = ''
            autoindex_format json;
            add_header Access-Control-Allow-Origin *;
          '';
        };
      };
    };

    # bind://ns2.oss.uzinfocom.uz
    nameserver = {
      enable = true;
      type = "slave";
    };

    # https://(hydra|cache).xinux.uz
    hydra.enable = true;
    nixpkgs.master = true;

    # https://git.oss.uzinfocom.uz
    git = {
      enable = true;
      domain = "git.oss.uzinfocom.uz";
      mail = config.sops.secrets."git/mail".path;
      database = config.sops.secrets."git/database".path;
      keys = {
        private = config.sops.secrets."git/key".path;
        public = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEouecGbpK0oYlJyQbxBMDlMVComaCi7fQtCM4jtTgm7 admin@oss.uzinfocom.uz";
      };
    };
  };
}
