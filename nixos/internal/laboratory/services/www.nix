{outputs, ...}: {
  imports = [outputs.nixosModules.web];

  # Enable web server & proxy
  services.www = {
    enable = true;

    default = {
      enable = true;
      cert = false;
      domain = "_";
    };

    hosts = {
      "minecraft.oss" = {
        locations."/" = {
          proxyPass = "http://0.0.0.0:8100";
          proxyWebsockets = true;
          extraConfig =
            "proxy_ssl_server_name on;"
            + "proxy_pass_header Authorization;";
        };
      };

      "dns.oss" = {
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
