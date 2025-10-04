{
  config,
  pkgs,
  ...
}: {
  services = {
    grafana = {
      enable = true;
      # domain = "grafana.oss";
      port = 2342;
      addr = "127.0.0.1";
    };
    prometheus = {
      enable = true;
      port = 9001;
      exporters = {
        node = {
          enable = true;
          enabledCollectors = ["systemd"];
          port = 9002;
        };
      };

      scrapeConfigs = [
        {
          job_name = "metrics";
          static_configs = [
            {
              targets = ["127.0.0.1:${toString config.services.prometheus.exporters.node.port}"];
            }
          ];
        }
      ];
    };
    loki = {
      enable = true;

      configuration = {
        auth_enabled = false;
        server = {
          http_listen_port = 3100;
          # grpc_listen_port = 0;
        };
        common = {
          ring = {
            instance_addr = "127.0.0.1";
            kvstore = {
              store = "inmemory";
            };
          };
          path_prefix = "/tmp/loki";
        };
        schema_config = {
          configs = [
            {
              from = "2020-05-15";
              store = "tsdb";
              object_store = "filesystem";
              schema = "v13";
              index = {
                prefix = "index_";
                period = "24h";
              };
            }
          ];
        };
        storage_config = {
          filesystem = {
            directory = "/tmp/loki/chunks";
          };
        };
      };
    };

    promtail = {
      # description = "Promtail service for Loki";
      # wantedBy = ["multi-user.target"];

      enable = true;
      configuration = {
        server = {
          http_listen_port = 28183;
          grpc_listen_port = 0;
        };
        positions = {
          filename = "/tmp/positions.yaml";
        };
        clients = [
          {
            url = "http://127.0.0.1:3100/loki/api/v1/push";
          }
        ];
        scrape_configs = [
          {
            job_name = "journal";
            journal = {
              max_age = "12h";
              labels = {
                job = "systemd-journal";
                host = "Laboratory";
              };
            };
            relabel_configs = [
              {
                source_labels = [
                  "__journal__systemd_unit"
                ];
                target_label = "unit";
              }
            ];
          }
        ];
      };
    };
  };
}
