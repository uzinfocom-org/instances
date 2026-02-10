{ lib }:
let
  # Appereantly, nix doesn't apply inside functions
  ustrings = import ./strings.nix { inherit lib; };

  makeSystem =
    {
      path,
      inputs,
      outputs,
    }:
    lib.nixosSystem {
      specialArgs = {
        inherit (outputs) lib;
        inherit inputs outputs;
      };
      modules = [
        # > Our main nixos configuration file <
        path
      ];
    };

  attrSystem =
    {
      list,
      inputs,
      outputs,
      path ? ../hosts,
    }:
    let
      # Generate absolute path to the configuration
      opath = alias: path + "/${alias}/configuration.nix";

      #   Name  =               Value
      # "Lorem" = self.lib.config.makeSystem "station";
      system = attr: {
        inherit (attr) name;
        value = makeSystem {
          inherit inputs outputs;
          path = opath attr.alias;
        };
      };
      # [
      #   { name = "Lorem", value = config }
      #   { name = "Ipsum", value = config }
      # ]
      map = lib.map system list;
    in
    lib.listToAttrs map;

  parseInstances =
    bpath: category:
    builtins.readDir (bpath + "/${category}")
    |> builtins.attrNames
    |> map (
      instance: with ustrings; {
        alias = "${category}/${instance}";
        name = capitalizeSplit "-" "${category}-${instance}";
      }
    );

  parseCategory =
    path: builtins.readDir path |> builtins.attrNames |> map (c: parseInstances path c) |> lib.flatten;

  autoConf =
    {
      inputs,
      outputs,
      path ? ../hosts,
    }:
    attrSystem {
      inherit inputs outputs;
      list = parseCategory path;
    };
in
{
  inherit makeSystem attrSystem autoConf;
}
