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
    main = "uchar.uz";

    client = "chat.${main}";
    server = "matrix.${main}";
    auth = "auth.${main}";
    mail = "mail.${main}";

    call = "call.${main}";
    livekit = "livekit.${main}";
    livekit-jwt = "livekit-jwt.${main}";
  };
in {
  imports = [
    # Module by @teutat3s
    outputs.nixosModules.mas

    # Parts of this configuration
    (import ./auth.nix {inherit config domains;})
    (import ./proxy {inherit lib domains pkgs config;})
    (import ./mail.nix {inherit inputs domains config;})
    (import ./server.nix {inherit lib config domains pkgs;})
  ];
}
