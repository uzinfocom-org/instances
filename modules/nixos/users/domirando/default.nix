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
  description = "Maftuna Vohidjonovna";
  githubKeysUrl = "https://github.com/domirando.keys";
  sha256 = "0pd2bv95w9yv7vb3vn5qa1s3w1yc7b68qd5xbm8c6y7hmnhckygl";
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
