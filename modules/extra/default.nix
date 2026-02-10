{
  lib,
  config,
  ...
}:
let
  cfg = config.uzinfocom.extra;
in
{
  imports = lib.modifier.loadModules ./.;

  options = {
    uzinfocom.extra = {
      enable = lib.options.mkOption {
        default = true;
        example = false;
        description = "Whether to add some extra configurations to the system.";
        type = lib.types.bool;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    uzinfocom = {
      # Documentations
      docs.enable = true;

      # Data Maintainance
      data.enable = true;

      # Update Management
      update.enable = true;
    };
  };

  meta = {
    doc = ./readme.md;
    buildDocsInSandbox = true;
    maintainers = with lib.maintainers; [ orzklv ];
  };
}
