{
  lib,
  pkgs,
  config,
  outputs,
  ...
}:
let
  # Matrix related domains
  domains = rec {
    main = "uzberk.uz";
    client = "chat.${main}";
    server = "matrix.${main}";
    auth = "mas.${main}";
    mail = "mail.${main}";

    call = "call.${main}";
    livekit = "livekit.${main}";
    livekit-jwt = "livekit-jwt.${main}";
  };
in
{
  imports = [
    # Parts of this configuration
    (import ./call.nix { inherit config domains pkgs; })
    (import ./proxy.nix {
      inherit
        lib
        domains
        pkgs
        config
        ;
    })
  ];
}
