{
  lib,
  config,
  ...
}:
let
  cfg = config.uzinfocom.apps.uzinfocom;
in
{
  imports = [
    ./website.nix
    ./social.nix
  ];

  options = {
    uzinfocom.apps.uzinfocom.enable = lib.mkEnableOption "Uzinfocom OSS'es Website";
  };

  config = lib.mkIf cfg.enable {
    uzinfocom.apps.uzinfocom = {
      website.enable = true;
      social.enable = true;
    };
  };
}
