# reference: https://www.reddit.com/r/NixOS/comments/17a46oh/does_nix_support_defining_attr_schemas_or_types/
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  users = [
    {
      username = "sakhib";
      hashedPassword = lib.strings.concatStrings [
        "$y$j9T$dsXOFHW"
        "CyplfRPiwsKu0l"
        "0$7YXPRLohyW8Q"
        "XfyITPP6Sag/l7"
        "XH3i7TO4uGByPK"
        "Bb2"
      ];
      description = "Sokhibjon Orzikulov";
      githubKeysUrl = "https://github.com/orzklv.keys";
      sha256 = "05rvkkk382jh84prwp4hafnr3bnawxpkb3w6pgqda2igia2a4865";
      homePath = builtins.toPath ./. + "/sakhib/home.nix";
    }
    {
      username = "shakhzod";
      hashedPassword = lib.strings.concatStrings [
        "$y$j9T$mi9V."
        "JCa4o3.QO2X2"
        "8vJo1$KzXKjk"
        "/5sN4lbsvF8B"
        "IEIwhKCL34e0"
        "gJxZEe.MMoT1"
        "B"
      ];
      description = "Shakhzod Kudratov";
      githubKeysUrl = "https://github.com/shakhzodkudratov.keys";
      sha256 = "0gnabwywc19947a3m4702m7ibhxmc5s4zqbhsydb2wq92k6qgh6g";
      homePath = builtins.toPath ./. + "/shakhzod/home.nix";
    }
    {
      username = "bahrom04";
      hashedPassword = "$y$j9T$PEPMAZlXHzgRwOlum.4JA0$sh0uNM1PxrWmSjRdjYkw2iiDdquWF3z9CDAaasEwQ88";
      description = "Baxrom Raxmatov";
      githubKeysUrl = "https://github.com/bahrom04.keys";
      sha256 = "0yazvxwvngyqapa7fz1qa7916c4w7km72smyl1im14mqbv8733k4";
      homePath = builtins.toPath ./. + "/bahrom04/home.nix";
    }
    {
      username = "letrec";
      hashedPassword = lib.strings.concatStrings [
        "$y$j9T$1TztZ"
        "x5c5Lp/QBhTf"
        "OffV1$RRY6mz"
        "6LNHoXtLNGVh"
        "igy2cu3XTeBu"
        "8GQrBewDr0oZD"
      ];
      description = "Hamidulloh Toʻxtayev";
      githubKeysUrl = "https://github.com/let-rec.keys";
      sha256 = "19yg67mljcy7a730i4ndvcb1dkqcvp0ccyggrs0qqvza5byliifg";
      homePath = builtins.toPath ./. + "/letrec/home.nix";
    }
    {
      username = "bemeritus";
      hashedPassword = "$y$j9T$G5x83.b0sXlsIFrdJvyQ5/$g.Rxw2YsfD4YzEVjNTyfCJWr/qpD.6kWFJECOzyFTg6";
      description = "BeMeritus";
      githubKeysUrl = "https://github.com/bemeritus.keys";
      sha256 = "0dr30cmzbiz192xfjfbb26sk9ynpwfla53q09hx6mr404rdszy9a";
      homePath = builtins.toPath ./. + "/bemeritus/home.nix";
    }
    {
      username = "domirando";
      hashedPassword = lib.strings.concatStrings [
        "$y$j9T$7uoELFRD8t70X8IiTMHn/.$QQt5GT21792Vr5BpL53rY1fFQw2iOJ95MYlZRvvDU74"
      ];
      description = "Maftuna Vohidjonovna";
      githubKeysUrl = "https://github.com/domirando.keys";
      sha256 = "0pd2bv95w9yv7vb3vn5qa1s3w1yc7b68qd5xbm8c6y7hmnhckygl";
      homePath = builtins.toPath ./. + "/domirando/home.nix";
    }
  ];

  nixosUsers = builtins.listToAttrs (builtins.map (i: {
      name = i.username;
      value = {
        hashedPassword = "${i.hashedPassword}";
        isNormalUser = true;
        description = "${i.description}";

        extraGroups = [
          "networkmanager"
          "wheel"
          "docker"
          "admins"
        ];

        openssh.authorizedKeys.keys = lib.mkIf ((i.githubKeysUrl != "") && (i.sha256 != "")) (
          lib.strings.splitString
          "\n"
          (
            builtins.readFile (
              builtins.fetchurl {
                url = "${i.githubKeysUrl}";
                sha256 = "${i.sha256}";
              }
            )
          )
        );
      };
    })
    users);

  homeUsers = builtins.listToAttrs (builtins.map (i: {
      # Import your home-manager configuration
      name = "${i.username}";
      value = import i.homePath {
        inherit pkgs inputs config lib;
      };
    })
    users);
in {
  config = {
    # mapped users
    users.users = nixosUsers;

    home-manager = {
      backupFileExtension = "hbak";

      extraSpecialArgs = {
        inherit inputs outputs;
      };
      # mapped home-manager
      users = homeUsers;
    };
  };
}
