{outputs, ...}: {
  imports = [outputs.nixosModules.web];

  # Enable web server & proxy
  services.www = {
    enable = true;

    default = {
      enable = true;
      cert = false;
      domain = "laboratory.local";
    };

    hosts = {
      "minecraft.local" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:8100";
          proxyWebsockets = true;
          extraConfig =
            "proxy_ssl_server_name on;"
            + "proxy_pass_header Authorization;";
        };
      };

      "dns.local" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:3000";
          proxyWebsockets = true;
          extraConfig =
            "proxy_ssl_server_name on;"
            + "proxy_pass_header Authorization;";
        };
      };
    };
  };
}
