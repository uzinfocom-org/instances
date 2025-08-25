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
    server = "matrix.${main}";
    auth = "auth.${main}";
    realm = "turn.${main}";
    mail = "mail.${main}";

    call = "call-2.${main}";
    livekit = "livekit-2.${main}";
    livekit-jwt = "livekit-jwt-2.${main}";
  };
in {
  imports = [
    # Module by @teutat3s
    outputs.nixosModules.mas

    # Parts of this configuration
    (import ./call.nix {inherit config domains;})
    (import ./proxy.nix {inherit lib domains pkgs config;})
  ];
}
