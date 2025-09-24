{...}: {
  # imports = [outputs.nixosModules.example];

  # ================================
  # Shameless advertisemesnt
  # Proudly generated with yaml to nix
  # https://xinux.uz/utils/yaml2nix
  # ================================

  # Enable adguard home
  services.adguardhome = {
    enable = true;
    mutableSettings = false;
    settings = {
      http = {
        pprof = {
          port = 6060;
          enabled = false;
        };
        address = "0.0.0.0:3000";
        session_ttl = "720h";
      };
      users = [
        {
          name = "uzinfocom";
          password = "$2a$10$5BjH8dzfFS.0hbm9WIXNse.vvf.UpyTsZIh2z7r67dLK3RvStAo7S";
        }
      ];
      auth_attempts = 5;
      block_auth_min = 15;
      http_proxy = "";
      language = "";
      theme = "auto";
      dns = {
        bind_hosts = [
          "0.0.0.0"
        ];
        port = 53;
        anonymize_client_ip = false;
        ratelimit = 20;
        ratelimit_subnet_len_ipv4 = 24;
        ratelimit_subnet_len_ipv6 = 56;
        ratelimit_whitelist = [
        ];
        refuse_any = true;
        upstream_dns = [
          "192.168.7.3"
        ];
        upstream_dns_file = "";
        bootstrap_dns = [
          "9.9.9.10"
          "149.112.112.10"
          "2620:fe::10"
          "2620:fe::fe:10"
        ];
        fallback_dns = [
          "8.8.8.8"
        ];
        upstream_mode = "load_balance";
        fastest_timeout = "1s";
        allowed_clients = [
        ];
        disallowed_clients = [
        ];
        blocked_hosts = [
          "version.bind"
          "id.server"
          "hostname.bind"
        ];
        trusted_proxies = [
          "127.0.0.0/8"
          "::1/128"
        ];
        cache_size = 4194304;
        cache_ttl_min = 0;
        cache_ttl_max = 0;
        cache_optimistic = false;
        bogus_nxdomain = [
        ];
        aaaa_disabled = false;
        enable_dnssec = false;
        edns_client_subnet = {
          custom_ip = "";
          enabled = false;
          use_custom = false;
        };
        max_goroutines = 300;
        handle_ddr = true;
        ipset = [
        ];
        ipset_file = "";
        bootstrap_prefer_ipv6 = false;
        upstream_timeout = "10s";
        private_networks = [
        ];
        use_private_ptr_resolvers = true;
        local_ptr_upstreams = [
        ];
        use_dns64 = false;
        dns64_prefixes = [
        ];
        serve_http3 = false;
        use_http3_upstreams = false;
        serve_plain_dns = true;
        hostsfile_enabled = true;
        pending_requests = {
          enabled = true;
        };
      };
      tls = {
        enabled = false;
        server_name = "";
        force_https = false;
        port_https = 443;
        port_dns_over_tls = 853;
        port_dns_over_quic = 853;
        port_dnscrypt = 0;
        dnscrypt_config_file = "";
        allow_unencrypted_doh = false;
        certificate_chain = "";
        private_key = "";
        certificate_path = "";
        private_key_path = "";
        strict_sni_check = false;
      };
      querylog = {
        dir_path = "";
        ignored = [
        ];
        interval = "2160h";
        size_memory = 1000;
        enabled = true;
        file_enabled = true;
      };
      statistics = {
        dir_path = "";
        ignored = [
        ];
        interval = "24h";
        enabled = true;
      };
      filters = [
        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt";
          name = "AdGuard DNS filter";
          id = 1;
        }
        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_2.txt";
          name = "AdAway Default Blocklist";
          id = 2;
        }
        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_24.txt";
          name = "1Hosts (Lite)";
          id = 1753716759;
        }
        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_64.txt";
          name = "1Hosts (Pro)";
          id = 1753716760;
        }
        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_59.txt";
          name = "AdGuard DNS Popup Hosts filter";
          id = 1753716761;
        }
        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_53.txt";
          name = "AWAvenue Ads Rule";
          id = 1753716762;
        }
        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_4.txt";
          name = "Dan Pollock's List";
          id = 1753716763;
        }
        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_34.txt";
          name = "HaGeZi's Normal Blocklist";
          id = 1753716764;
        }
        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_48.txt";
          name = "HaGeZi's Pro Blocklist";
          id = 1753716765;
        }
        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_51.txt";
          name = "HaGeZi's Pro++ Blocklist";
          id = 1753716766;
        }
        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_49.txt";
          name = "HaGeZi's Ultimate Blocklist";
          id = 1753716767;
        }
        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_5.txt";
          name = "OISD Blocklist Small";
          id = 1753716768;
        }
        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_27.txt";
          name = "OISD Blocklist Big";
          id = 1753716769;
        }
        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_3.txt";
          name = "Peter Lowe's Blocklist";
          id = 1753716770;
        }
        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_33.txt";
          name = "Steven Black's List";
          id = 1753716771;
        }
      ];
      whitelist_filters = [
      ];
      user_rules = [
      ];
      dhcp = {
        enabled = false;
        interface_name = "";
        local_domain_name = "lan";
        dhcpv4 = {
          gateway_ip = "";
          subnet_mask = "";
          range_start = "";
          range_end = "";
          lease_duration = 86400;
          icmp_timeout_msec = 1000;
          options = [
          ];
        };
        dhcpv6 = {
          range_start = "";
          lease_duration = 86400;
          ra_slaac_only = false;
          ra_allow_slaac = false;
        };
      };
      filtering = {
        blocking_ipv4 = "";
        blocking_ipv6 = "";
        blocked_services = {
          schedule = {
            time_zone = "UTC";
          };
          ids = [
          ];
        };
        protection_disabled_until = null;
        safe_search = {
          enabled = false;
          bing = true;
          duckduckgo = true;
          ecosia = true;
          google = true;
          pixabay = true;
          yandex = true;
          youtube = true;
        };
        blocking_mode = "default";
        parental_block_host = "family-block.dns.adguard.com";
        safebrowsing_block_host = "standard-block.dns.adguard.com";
        rewrites = [
          {
            domain = "xinux.oss";
            answer = "10.10.0.2";
          }
          {
            domain = "minecraft.oss";
            answer = "10.10.0.2";
          }
          {
            domain = "dns.oss";
            answer = "10.10.0.2";
          }
          {
            domain = "router.oss";
            answer = "10.10.0.1";
          }
          {
            domain = "grafana.oss";
            answer = "10.10.0.2";
          }
        ];
        safe_fs_patterns = [
          "/var/lib/private/AdGuardHome/userfilters/*"
        ];
        safebrowsing_cache_size = 1048576;
        safesearch_cache_size = 1048576;
        parental_cache_size = 1048576;
        cache_time = 30;
        filters_update_interval = 24;
        blocked_response_ttl = 10;
        filtering_enabled = true;
        parental_enabled = false;
        safebrowsing_enabled = false;
        protection_enabled = true;
      };
      clients = {
        runtime_sources = {
          whois = true;
          arp = true;
          rdns = true;
          dhcp = true;
          hosts = true;
        };
        persistent = [
        ];
      };
      log = {
        enabled = true;
        file = "";
        max_backups = 0;
        max_size = 100;
        max_age = 3;
        compress = false;
        local_time = false;
        verbose = false;
      };
      os = {
        group = "";
        user = "";
        rlimit_nofile = 0;
      };
      schema_version = 29;
    };
  };

  networking.firewall.allowedTCPPorts = [53];
  networking.firewall.allowedUDPPorts = [53];
}
