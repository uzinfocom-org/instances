# reference: https://www.reddit.com/r/NixOS/comments/17a46oh/does_nix_support_defining_attr_schemas_or_types/
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  # options = {
  #   username = lib.mkOption {
  #     type = lib.types.str;
  #     default = "";
  #     description = "Is installed packages are MacOS targetted.";
  #   };
  # };
  username = "bahrom04";
  hashedPassword = "$y$j9T$PEPMAZlXHzgRwOlum.4JA0$sh0uNM1PxrWmSjRdjYkw2iiDdquWF3z9CDAaasEwQ88";
  description = "Baxrom Raxmatov";
  githubKeysUrl = "https://github.com/bahrom04.keys";
  sha256 = "0yazvxwvngyqapa7fz1qa7916c4w7km72smyl1im14mqbv8733k4";
  homePath = builtins.toPath ./. + "/home.nix";
  mkUsers = outputs.lib.users.mkUsers {
    inherit
      inputs
      outputs
      lib
      config
      pkgs
      # for mkUser
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
