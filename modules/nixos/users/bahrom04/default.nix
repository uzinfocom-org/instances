{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  username = "bahrom04";

  hashedPassword = lib.strings.concatStrings [
    "$y$j9T$PEPMAZlXHzgRwOlum.4JA0$sh0uNM1PxrWmSjRdjYkw2iiDdquWF3z9CDAaasEwQ88"
  ];
in {
  config = {
    users.users = {
      "${username}" = {
        inherit hashedPassword;
        isNormalUser = true;
        # isAutist = true;
        # isKonchenniy = "definitely";
        description = "Baxrom Raxmatov";

        extraGroups = [
          "networkmanager"
          "wheel"
          "docker"
          "admins"
        ];

        openssh.authorizedKeys.keys = lib.strings.splitString "\n" (
          builtins.readFile (
            builtins.fetchurl {
              url = "https://github.com/bahrom04.keys";
              sha256 = "0yazvxwvngyqapa7fz1qa7916c4w7km72smyl1im14mqbv8733k4";
            }
          )
        );
      };
    };

    home-manager = {
      backupFileExtension = "hbak";

      extraSpecialArgs = {
        inherit inputs outputs;
      };

      users = {
        # Import your home-manager configuration
        "${username}" = import ./home.nix {
          inherit pkgs inputs outputs username lib config;
        };
      };
    };
  };
}
