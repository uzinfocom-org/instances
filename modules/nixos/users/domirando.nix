{
  inputs,
  outputs,
  lib,
  ...
}: let
  username = "domirando";

  hashedPassword = lib.strings.concatStrings [
    "$y$j9T$7uoELFRD8t70X8IiTMHn/.$QQt5GT21792Vr5BpL53rY1fFQw2iOJ95MYlZRvvDU74"
  ];
in {
  config = {
    users.users = {
      "${username}" = {
        inherit hashedPassword;
        isNormalUser = true;
        description = "Maftuna Vohidjonovna";

        extraGroups = [
          "networkmanager"
          "wheel"
          "docker"
          "admins"
        ];

        openssh.authorizedKeys.keys = lib.strings.splitString "\n" (
          builtins.readFile (
            builtins.fetchurl {
              url = "https://github.com/domirando.keys";
              sha256 = "AAAAC3NzaC1lZDI1NTE5AAAAIHYu4EH07HdsblBP+WbVL1ym9IAMfD15Cn6iN4auOEnI";
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
