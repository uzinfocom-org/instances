{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.uzinfocom.runners;

  mkGitHub = param: {
    github-runners = {
      "Uzinfocom-${param.name}" = {
        inherit (param) enable url;
        inherit (cfg) user group;
        tokenFile = param.token;
        replace = true;
        extraLabels = [ param.name ] ++ (lib.optionals (param.label != null) [ param.label ]);
        package = pkgs.unstable.github-runner;
        workDir = "/srv/runner/github/${lib.toLower param.name}";
        extraPackages = with pkgs; [
          gh
          nodejs_24
        ];
        serviceOverrides = {
          Restart = lib.mkForce "always";
          ProtectSystem = "full";
          StateDirectory = [
            "github-runner/Uzinfocom-${param.name}"
            "/srv/runner/github/${lib.toLower param.name}"
          ];
          ReadWritePaths = "${config.uzinfocom.data.path or "/srv"}";
          PrivateMounts = false;
          UMask = 22;
        };
      };
    };
  };

  mkForgejo = param: {
    gitea-actions-runner = {
      package = lib.mkDefault pkgs.unstable.forgejo-runner;
      instances."Uzinfocom-${param.name}" = {
        inherit (param) enable name url;
        tokenFile = param.token;
        labels = [ "native:host" ];
        hostPackages = with pkgs; [
          bash
          coreutils
          curl
          gawk
          gitMinimal
          gnused
          nodejs
          wget
          nix
          nodejs_24
        ];
      };
    };
  };

  patchForgejo = param: {
    "gitea-runner-Uzinfocom-${param.name}" = {
      restartIfChanged = false;
      serviceConfig = {
        DynamicUser = lib.mkForce false;
        User = lib.mkForce cfg.user;
        Group = lib.mkForce cfg.group;
      };
    };
  };
in
{
  options = {
    uzinfocom.runners = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable git hosting provider runners";
      };

      instances = lib.mkOption {
        type = with lib.types; listOf (submodule lib.utypes.runner);
        description = "List of runner instances to be hosted.";
        default = [ ];
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "runner";
        example = "git-runner";
        description = "Enable git hosting provider runners.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "runner";
        example = "git-runner";
        description = "Enable git hosting provider runners.";
      };
    };
  };

  config =
    let
      extra = [
        {
          gitea-actions-runner = {
            package = pkgs.unstable.forgejo-runner;
          };
        }
      ];

      result = lib.lists.forEach cfg.instances (
        param:
        (lib.rmatch.match param [
          [
            { type = "github"; }
            (mkGitHub param)
          ]
          [
            { type = "forgejo"; }
            (mkForgejo param)
          ]
        ])
      );
    in
    lib.mkIf cfg.enable {
      users.users.${cfg.user} = {
        inherit (cfg) group;
        description = "Git Runner user";
        isNormalUser = true;
        createHome = false;
        extraGroups = [ "admins" ];
      };

      users.groups.${cfg.group} = { };

      services = lib.mkMerge (result ++ extra);

      systemd.services =
        cfg.instances |> builtins.filter (i: i.type == "forgejo") |> map patchForgejo |> lib.mkMerge;
    };

  meta = {
    doc = ./readme.md;
    buildDocsInSandbox = true;
    maintainers = with lib.maintainers; [ orzklv ];
  };
}
