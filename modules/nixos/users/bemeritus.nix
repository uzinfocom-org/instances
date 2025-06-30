{
  inputs,
  outputs,
  lib,
  ...
}: let
  username = "bemeritus";

  hashedPassword = lib.strings.concatStrings [
    "$y$j9T$G5x83.b0sXlsIFrdJvyQ5/$g.Rxw2YsfD4YzEVjNTyfCJWr/qpD.6kWFJECOzyFTg6"
  ];
in {
  config = {
    users.users = {
      "${username}" = {
        inherit hashedPassword;
        isNormalUser = true;
        # isAutist = true;
        # isKonchenniy = "definitely";
        description = "BeMeritus";

        extraGroups = [
          "networkmanager"
          "wheel"
          "docker"
          "admins"
        ];

        openssh.authorizedKeys.keys = lib.strings.splitString "\n" (
          builtins.readFile (
            builtins.fetchurl {
              url = "https://github.com/bemeritus.keys";
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