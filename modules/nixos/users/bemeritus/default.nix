{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  username = "bemeritus";
  hashedPassword = "$y$j9T$G5x83.b0sXlsIFrdJvyQ5/$g.Rxw2YsfD4YzEVjNTyfCJWr/qpD.6kWFJECOzyFTg6";
  description = "BeMeritus";
  githubKeysUrl = "https://github.com/bemeritus.keys";
  sha256 = "0dr30cmzbiz192xfjfbb26sk9ynpwfla53q09hx6mr404rdszy9a";
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
