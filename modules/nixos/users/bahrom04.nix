{
  inputs,
  outputs,
  lib,
  ...
}: let
  username = "bahrom04";

  hashedPassword = lib.strings.concatStrings [
    "$y$j9T$PEPMAZlXHzgRwOlum"
    ".4JA0$sh0uNM1PxrWmSjRdjYkw2ii"
    "DdquWF3z9CDAaasEwQ88"
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
              sha256 = "0gnabwywc19947a3m4702m7ibhxmc5s4zqbhsydb2wq92k6qgh6g";
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
        "${username}" = import ../../../home.nix {
          inherit inputs outputs username lib;
        };
      };
    };
  };
}
