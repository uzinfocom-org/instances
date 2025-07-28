{
  inputs,
  lib,
  pkgs,
  ...
}: let
  # Global variables
  version = "1.21.8";
in {
  imports = [inputs.minecraft.nixosModules.minecraft-servers];

  services.minecraft-servers = {
    enable = true;
    eula = true;
    dataDir = "/var/lib/minecraft";
    servers = {
      slave = let
        server = lib.replaceStrings ["."] ["_"] "paper-${version}";
      in {
        enable = true;
        openFirewall = true;
        package = pkgs.paperServers.${server};
        jvmOpts = "-Xms8196M -Xmx8196M -XX:+UseG1GC -XX:ParallelGCThreads=2 -XX:MinHeapFreeRatio=5 -XX:MaxHeapFreeRatio=10";

        serverProperties = {
          server-port = 25565;
          difficulty = 3;
          gamemode = 0;
          max-players = 10;
          motd = "\\u00A7f\\u00A7lWelcome to Uzinfocom Open Source's Server\\u00A7r\\n\\u00A7lMore at\:\\u00A7r \\u00A7nhttp\://laboratory.local";
          white-list = true;
          enable-rcon = true;
          "rcon.port" = 25575;
          "rcon.password" = "F1st1ng15300Buck!?";
        };

        whitelist = {
          Orzklv = "3e220001-9544-48bb-8fd0-ca7139727207";
          Shakhz = "1c786ec6-0f65-4448-9ecf-ab53b75bf867";
          Nixxer = "8fdd80ef-c294-432d-b381-e43353a3db27";
          Bahrom04 = "15f652bf-33f9-4a08-aaf1-acc6a019c504";
          Thelis = "2c3a8eb7-921b-4e4a-ba60-c5e3a83d941f";
          Domirando = "5432bfe3-2685-4223-ba25-81600dd041bc";
        };

        symlinks = with pkgs; {
          "plugins/BlueMap" = ./plugins/BlueMap;
          "plugins/bluemap-spigot.jar" = fetchurl {
            url = "https://cdn.modrinth.com/data/swbUV1cr/versions/ucikJabQ/bluemap-5.10-spigot.jar";
            hash = "sha256-6b0QhRcCI7MmAETHDryebDtUHN74D5ifQ185DVEM+YI=";
          };
          "plugins/Chunky-Bukkit.jar" = fetchurl {
            url = "https://cdn.modrinth.com/data/fALzjamp/versions/P3y2MXnd/Chunky-Bukkit-1.4.40.jar";
            hash = "sha256-KlR3/ID3EBLhWt4c402+uDbhdiOyjbESSSwPFEPAlyE=";
          };
          "server-icon.png" = ./server-icon.png;
        };
      };
    };
  };

  networking.firewall = {
    allowedTCPPorts = [25565];
    allowedUDPPorts = [25565];
  };
}
