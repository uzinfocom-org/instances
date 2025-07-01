{
  inputs,
  outputs,
  lib,
  config, 
  pkgs,
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
              sha256 = "0pd2bv95w9yv7vb3vn5qa1s3w1yc7b68qd5xbm8c6y7hmnhckygl";
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
          inherit outputs config pkgs;
        };
      };
    };
  };
}
