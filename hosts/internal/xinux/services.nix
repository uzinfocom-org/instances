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
    outputs.nixosModules.git
    outputs.nixosModules.bind
    outputs.nixosModules.hydra
    outputs.nixosModules.runner
  ];

  sops = {
    secrets = {
      # Forgejo
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

      # Runners
      "forgejo/oss" = runner-sm;
      "github/uzinfocom" = runner-sm;
      "github/floss" = runner-sm;
      "github/floss-community" = runner-sm;
      "github/xinux" = runner-sm;
      "github/rust-lang" = runner-sm;
      "github/uchar" = runner-sm;
      "github/bleur" = runner-sm;
      "github/uzbek" = runner-sm;
    };

    templates = {
      "gitea-forgejo-uzinfocom" = {
        owner = config.uzinfocom.runners.user;
        content = ''
          TOKEN=${config.sops.placeholder."forgejo/oss"}
        '';
      };
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

    # * -> github.com
    runners = {
      enable = true;
      instances = [
        {
          name = "Default";
          url = "https://git.oss.uzinfocom.uz";
          token = config.sops.templates."gitea-forgejo-uzinfocom".path;
          type = "forgejo";
        }
        {
          name = "Uzinfocom";
          url = "https://github.com/uzinfocom-org";
          token = config.sops.secrets."github/uzinfocom".path;
          type = "github";
        }
        {
          name = "Xinux";
          url = "https://github.com/xinux-org";
          token = config.sops.secrets."github/xinux".path;
          type = "github";
        }
        {
          name = "Uchar";
          url = "https://github.com/uchar-org";
          token = config.sops.secrets."github/uchar".path;
          type = "github";
        }
        {
          name = "Bleur";
          url = "https://github.com/bleur-org";
          token = config.sops.secrets."github/bleur".path;
          type = "github";
        }
      ];
    };
  };
}
