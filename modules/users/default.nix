{
  lib,
  config,
  ...
}:
let
  cfg = config.uzinfocom.accounts;

  sudoless = {
    # Don't ask for password
    security.sudo.wheelNeedsPassword = false;
  };

  generic =
    let
      teams = lib.flatten (map (team: team.members) cfg.teams);

      all = cfg.users ++ teams;

      merge = lib.unique all;
    in
    lib.users.mkUsers merge;
in
{
  options = {
    uzinfocom.accounts = {
      teams = lib.options.mkOption {
        default = with lib.uteams; [
          leads
          admins
        ];
        example = [ lib.uteams.prisioners ];
        description = "Team of users to be added to the system.";
        type = with lib.types; with lib.utypes; listOf (submodule groups);
      };

      users = lib.options.mkOption {
        default = [ lib.umembers.orzklv ];
        example = [ lib.umembers.shakhzod ];
        description = "Users to be added to the system.";
        type = with lib.types; with lib.utypes; listOf (submodule users);
      };
    };
  };

  config = lib.mkMerge [
    generic
    sudoless
  ];

  meta = {
    doc = ./readme.md;
    buildDocsInSandbox = true;
    maintainers = with lib.maintainers; [ orzklv ];
  };
}
