{
  lib,
  config,
  inputs,
  ...
}:
let
  cfg = config.uzinfocom.matrix;

  publicDomain = "matrix.${cfg.domain}";
  serverDomain = "${cfg.domain}";
in
{
  imports = [
    # Proxy reversing
    ./proxy
  ];

  options = {
    uzinfocom.matrix = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Matrix deployment module.";
      };

      domain = lib.mkOption {
        type = lib.types.str;
        example = "uzinfocom.uz";
        description = "Domain to associate matrix network with.";
      };

      cap = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Setup matrix instance to use oidc/ldap.";
      };

      call = lib.mkOption {
        type = lib.types.enum [
          "matrix"
          "self-hosted"
        ];
        default = "matrix";
        example = "uchar";
        description = "Livekit server to redirect clients to use Call features.";
      };

      synapse = {
        app-service-config-files = lib.mkOption {
          description = "List of app service config files";
          type = lib.types.listOf lib.types.str;
          default = [ ];
        };

        extra-config-files = lib.mkOption {
          description = "List of extra synapse config files";
          type = lib.types.listOf lib.types.str;
          default = [ ];
        };

        signing_key_path = lib.mkOption {
          description = "Path to file containing the signing key";
          type = lib.types.str;
          default = "${config.services.matrix-synapse.dataDir}/homeserver.signing.key";
        };
      };

      matrix-authentication-service = {
        extra-config-files = lib.mkOption {
          description = "List of extra mas config files";
          type = lib.types.listOf lib.types.str;
          default = [ ];
        };
      };

      matrix-sygnal = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          example = true;
          description = "Enable independent push module for matrix instance";
        };

        config-file = lib.mkOption {
          description = "Configuration file to feed push service";
          type = lib.types.str;
          default = "/var/lib/matrix-sygnal/push.yaml";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # generate nginx upstreams for configured workers
    services = {
      matrix-tuwunel = {
        enable = true;

        extraEnvironment = {
          RUST_BACKTRACE = "yes";
        };

        settings = {
          global = {
            # Name of the server (not sub)
            server_name = serverDomain;

            # Every user will have: "Unknown 🇺🇿"
            new_user_displayname_suffix = "🇺🇿";

            # Addresses where server will be available from
            address = [
              "127.0.0.1"
              "::1"
            ];

            # Port to host on
            port = 8008;

            # If socket is preferred instead of ports
            unix_socket_path = "/run/tuwunel/tuwunel.sock";

            # Keep database backups here...
            database_backup_path = "/opt/matrix-db-backup";

            # There should be one replica of db
            database_backups_to_keep = 1;

            # Maximum upload size
            max_request_size = "1024 MiB";

            # Whether to allow user registration
            allow_registration = false;

            # Path to registration token if allowed
            registration_token_file = "";

            # Allow creation of encrypted rooms
            allow_encryption = true;

            # Controls whether locally-created rooms should be end-to-end encrypted by
            # default
            encryption_enabled_by_default_for_room_type = "invite";

            # Controls whether federation is allowed or not
            allow_federation = true;

            # Sets the default `m.federate` property for newly created rooms when the
            # client does not request one
            federate_created_rooms = true;

            # Allows federation requests to be made to itself
            federation_loopback = true;

            # Set this to true to allow your server's public room directory to be
            # federated
            allow_public_room_directory_over_federation = true;

            # Set this to true to allow your server's public room directory to be
            # queried without client authentication (access token) through the Client
            # APIs
            allow_public_room_directory_without_auth = true;

            # Allows room directory searches to match on partial room_id's when the
            # search term starts with '!'
            allow_public_room_search_by_id = true;

            # Show all local users in user directory
            show_all_local_users_in_user_directory = true;

            # Allow standard users to create rooms
            allow_room_creation = true;

            # For compatibility and special purpose use only
            push_everything = true;

            # Setting this option to true replaces the list of identity
            # providers displayed on a client's login page with a single button "Sign
            # in with single sign-on" linking to the URL
            # https://github.com/matrix-construct/tuwunel/blob/7df373524e54393e156b13b83f0bd07dcc5f1987/tuwunel-example.toml#L1912C18-L1928
            single_sso = false;

            well_known = {
              # The server URL that the client well-known file will serve
              client = "https://${publicDomain}";

              # The server base domain of the URL with a specific port that the server
              # well-known file will serve.
              server = "${publicDomain}:443";

              # The URL of the support web page
              support_page = "https://${serverDomain}";

              # The name of the support role
              support_role = "m.role.admin";

              # The email address for the above support role
              support_email = "support@${serverDomain}";

              # The Matrix User ID for the above support role
              support_mxid = "@orzklv:floss.uz";

              # Element Call / MatrixRTC configuration (MSC4143).
              rtc_transports = [
                {
                  type = "livekit";
                  livekit_service_url = "https://livekit.${serverDomain}";
                }
              ];
            };

            identity_provider = {
              # Identity of IDM
              brand = "MAS";

              # Registered client id from IDM
              client_id = "0000000000000000000SYNAPSE";

              # TODO: make it through sops
              client_secret_file = "";

              # https://github.com/matrix-construct/tuwunel/blob/7df373524e54393e156b13b83f0bd07dcc5f1987/tuwunel-example.toml#L2256-L2264
              issuer_url = "https://mas.uchar.uz/";

              # https://github.com/matrix-construct/tuwunel/blob/7df373524e54393e156b13b83f0bd07dcc5f1987/tuwunel-example.toml#L2266-L2273
              callback_url = "https://mas.uchar.uz/oauth2/introspect";

              # https://github.com/matrix-construct/tuwunel/blob/7df373524e54393e156b13b83f0bd07dcc5f1987/tuwunel-example.toml#L2275-L2296
              default = true;
            };
          };
        };
      };

      matrix-authentication-service = {
        enable = true;
        createDatabase = true;
        extraConfigFiles = config.uzinfocom.matrix.matrix-authentication-service.extra-config-files;

        # https://element-hq.github.io/matrix-authentication-service/reference/configuration.html
        settings = {
          account =
            if cfg.cap then
              {
                email_change_allowed = false;
              }
            else
              {
                email_change_allowed = true;
                displayname_change_allowed = true;
                password_registration_enabled = true;
                password_change_allowed = true;
                password_recovery_enabled = true;
              };
          http = {
            public_base = "https://mas.${cfg.domain}";
            issuer = "https://mas.${cfg.domain}";
            listeners = [
              {
                name = "web";
                resources = [
                  { name = "discovery"; }
                  { name = "human"; }
                  { name = "oauth"; }
                  { name = "compat"; }
                  { name = "graphql"; }
                  {
                    name = "assets";
                    path = "${config.services.matrix-authentication-service.package}/share/matrix-authentication-service/assets";
                  }
                ];
                binds = [
                  {
                    host = "0.0.0.0";
                    port = 8090;
                  }
                ];
                proxy_protocol = false;
              }
              {
                name = "internal";
                resources = [
                  { name = "health"; }
                ];
                binds = [
                  {
                    host = "0.0.0.0";
                    port = 8081;
                  }
                ];
                proxy_protocol = false;
              }
            ];
          };
          passwords =
            if cfg.cap then
              {
                enabled = false;
              }
            else
              {
                enabled = true;
                minimum_complexity = 3;
                schemes = [
                  {
                    version = 1;
                    algorithm = "argon2id";
                  }
                  {
                    version = 2;
                    algorithm = "bcrypt";
                  }
                ];
              };
        };
      };

      matrix-sygnal = lib.mkIf cfg.matrix-sygnal.enable {
        inherit (cfg.matrix-sygnal) enable;
        configFile = cfg.matrix-sygnal.config-file;
      };
    };
  };

  meta = {
    doc = ./readme.md;
    buildDocsInSandbox = true;
    maintainers = with lib.maintainers; [ orzklv ];
  };
}
