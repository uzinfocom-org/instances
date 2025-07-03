{
  inputs,
  outputs,
  lib,
  config,
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
  description = "Hamidulloh Toʻxtayev";
  githubKeysUrl = "https://github.com/let-rec.keys";
  sha256 = "19yg67mljcy7a730i4ndvcb1dkqcvp0ccyggrs0qqvza5byliifg";
  homePath = builtins.toPath ./. + "/home.nix";
  mkUsers = outputs.lib.users.mkUsers {
    inherit
      inputs
      outputs
      lib
      config
      pkgs
      # for mkUsers
      username
      hashedPassword
      description
      githubKeysUrl
      sha256
      homePath
      ;
  };
in {
  config = mkUsers;
}
