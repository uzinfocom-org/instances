{
  lib,
  pkgs,
  config,
  inputs,
  outputs,
  ...
}: let
  # Matrix related domains
  domains = rec {
    main = "uzberk.uz";
    client = "chat.${main}";
    call = "call.${main}";
    server = "matrix.${main}";
    auth = "auth.${main}";
    realm = "turn.${main}";
    mail = "mail.${main}";
    livekit = "livekit.${main}";
    livekit-jwt = "livekit-jwt.${main}";
  };
in {
  imports = [
    # Module by @teutat3s
    outputs.nixosModules.matrix

    # Parts of this configuration
    (import ./call.nix {inherit config domains;})
    (import ./proxy.nix {inherit lib domains pkgs config;})
  ];
}
