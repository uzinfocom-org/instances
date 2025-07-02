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
  github_keys_url = "https://github.com/bahrom04.keys";
  sha256 = "0yazvxwvngyqapa7fz1qa7916c4w7km72smyl1im14mqbv8733k4";
  home_nix_path = builtins.toPath ./. + "/home.nix";
  mkUser = import ../mkUser.nix {
    inherit
      inputs
      outputs
      lib
      config
      pkgs
      username
      hashedPassword
      description
      github_keys_url
      sha256
      home_nix_path
      ;
  };
in {
  config = mkUser;
}
