{
  lib,
  pkgs,
  config,
  outputs,
  ...
}: let
  # Matrix related domains
  domains = rec {
    main = "uzberk.uz";
    client = "chat.${main}";
    server = "matrix.${main}";
    auth = "auth.${main}";
    realm = "turn.${main}";
    mail = "mail.${main}";

    call = "call.${main}";
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
