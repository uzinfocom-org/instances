{
  lib,
  config,
  domains,
  pkgs,
}:
let
  commonHeaders = ''
    add_header Permissions-Policy interest-cohort=() always;
    add_header Strict-Transport-Security "max-age=63072000; includeSubDomains" always;
    add_header X-XSS-Protection "1; mode=block";
  '';
in
{
  uzinfocom.www.hosts = {
    ${domains.livekit} = {
      forceSSL = lib.mkDefault true;
      enableACME = lib.mkDefault true;

      locations = {
        "/" = {
          proxyWebsockets = true;
          proxyPass = "http://[::1]:${toString config.services.livekit.settings.port}";
          priority = 400;
          extraConfig = ''
            proxy_send_timeout 120;
            proxy_read_timeout 120;
            proxy_buffering off;

            proxy_set_header Accept-Encoding gzip;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
          '';
        };
      };
    };

    ${domains.livekit-jwt} = {
      forceSSL = lib.mkDefault true;
      enableACME = lib.mkDefault true;

      locations = {
        "/" = {
          priority = 400;
          proxyPass = "http://[::1]:${toString config.services.lk-jwt-service.port}";
        };
      };
    };

    ${domains.call} = {
      forceSSL = lib.mkDefault true;
      enableACME = lib.mkDefault true;
      root = pkgs.element-call;
      extraConfig = commonHeaders;

      locations = {
        "/config.json" =
          let
            data = {
              default_server_config = {
                "m.homeserver" = {
                  "base_url" = "https://${domains.server}";
                  "server_name" = domains.main;
                };
              };
              livekit.livekit_service_url = "https://${domains.livekit-jwt}";
            };
          in
          {
            extraConfig = ''
              default_type application/json;
              return 200 '${builtins.toJSON data}';
            '';
          };

        "/" = {
          extraConfig = ''
            try_files $uri /$uri /index.html;
          '';
        };
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 8448 ];
}
