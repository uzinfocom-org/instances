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

    call = "call.${main}";
    livekit = "livekit.${main}";
    livekit-jwt = "livekit-jwt.${main}";
  };
in {
  imports = [
    # Module by @teutat3s
    outputs.nixosModules.matrix

    # Parts of this configuration
    (import ./proxy {inherit lib domains pkgs;})
    (import ./auth.nix {inherit config domains;})
    (import ./mail.nix {inherit inputs domains config;})
    (import ./server.nix {inherit lib config domains pkgs;})
  ];
}
