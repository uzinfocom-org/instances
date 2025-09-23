{
  config,
  pkgs,
  ...
}: {
  services = {
    grafana = {
      enable = true;
      domain = "grafana.oss";
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
          http_listen_port = 28183;
          grpc_listen_port = 0;
        };

        scrape_configs = [
          {
            job_name = "journal";
            journal = {
              labels = {
                job = "systemd-journal";
                host = "Laboratory";
              };
            };
            relabel_configs = {
              source_labels = ["__journal__systemd_unit"];
              target_label = "unit";
            };
          }
        ];
      };
    };
  };
}
