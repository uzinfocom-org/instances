{
  inputs,
  outputs,
  lib,
  pkgs,
  ...
}: let
  username = "letrec";

  hashedPassword = lib.strings.concatStrings [
    "$y$j9T$1TztZ"
    "x5c5Lp/QBhTf"
    "OffV1$RRY6mz"
    "6LNHoXtLNGVh"
    "igy2cu3XTeBu"
    "8GQrBewDr0oZD"
  ];
in {
  config = {
    users.users = {
      "${username}" = {
        inherit hashedPassword;
        isNormalUser = true;
        # isAutist = true;
        # isKonchenniy = "definitely";
        description = "Hamidulloh To'xtayev";

        extraGroups = [
          "networkmanager"
          "wheel"
          "docker"
          "admins"
        ];

        openssh.authorizedKeys.keys = lib.strings.splitString "\n" (
          builtins.readFile (
            builtins.fetchurl {
              url = "https://github.com/let-rec.keys";
              sha256 = "19yg67mljcy7a730i4ndvcb1dkqcvp0ccyggrs0qqvza5byliifg";
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
          inherit inputs lib pkgs;
        };
      };
    };
  };
}
