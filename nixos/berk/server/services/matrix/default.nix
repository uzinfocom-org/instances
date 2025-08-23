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

    # Instance I
    call = "call.${main}";
    livekit = "livekit.${main}";
    livekit-jwt = "livekit-jwt.${main}";

    # Instance II
    call-2 = "call-2.${main}";
    livekit-2 = "livekit-2.${main}";
    livekit-jwt-2 = "livekit-jwt-2.${main}";
  };
in {
  imports = [
    # Module by @teutat3s
    outputs.nixosModules.mas

    # Parts of this configuration
    (import ./proxy {inherit lib domains pkgs;})
    (import ./auth.nix {inherit config domains;})
    (import ./mail.nix {inherit inputs domains config;})
    (import ./server.nix {inherit lib config domains pkgs;})
  ];
}
