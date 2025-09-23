{
  #    __  __      _       ____
  #   / / / /___  (_)___  / __/___  _________  ____ ___
  #  / / / /_  / / / __ \/ /_/ __ \/ ___/ __ \/ __ `__ \
  # / /_/ / / /_/ / / / / __/ /_/ / /__/ /_/ / / / / / /
  # \____/ /___/_/_/ /_/_/  \____/\___/\____/_/ /_/ /_/
  description = "Configurations for various instances hosted by Uzinfocom Open Source";

  # inputs are other flakes you use within your own flake, dependencies
  # for your flake, etc.
  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Also see the 'unstable-packages' overlay at 'overlays/home.nix'.

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Disko
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Flake utils for eachSystem
    flake-utils.url = "github:numtide/flake-utils";

    # Secrets management
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Generate images
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Mail Server
    simple-nixos-mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-25.05";

    # Uzinfocom's packages repository
    uzinfocom-pkgs = {
      url = "github:uzinfocom-org/pkgs";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-unstable.follows = "nixpkgs-unstable";
      };
    };

    # Git hooks
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Minecraft server
    minecraft.url = "github:Infinidoge/nix-minecraft";

    # User configurations
    orzklv = {
      url = "github:orzklv/nix/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    bahrom04 = {
      url = "github:bahrom04/nix-config?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    letrec = {
      url = "github:let-rec/nix-conf?ref=master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    domirando = {
      url = "github:domirando/sysconfig";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    bemeritus = {
      url = "github:bemeritus/dotfiles?ref=master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lambdajon = {
      url = "github:lambdajon/confs?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    flake-utils,
    uzinfocom-pkgs,
    pre-commit-hooks,
    ...
  } @ inputs: let
    # Self instance pointer
    outputs = self;
  in
    # Attributes for each system
    flake-utils.lib.eachDefaultSystem
    (
      system: let
        inherit (self.checks.${system}) pre-commit-check;
        # Packages for the current <arch>
        pkgs = nixpkgs.legacyPackages.${system};
      in
        # Nixpkgs packages for the current system
        {
          # Tests and suites for this repo
          checks = {
            pre-commit-check = pre-commit-hooks.lib.${system}.run {
              src = ./.;
              hooks = {
                statix.enable = true;
                alejandra.enable = true;

                # When things get nasty
                #flake-checker.enable = true;
              };
            };
          };

          # Development shells
          devShells = {
            default = pkgs.callPackage ./shell.nix {inherit pkgs pre-commit-hooks pre-commit-check;};
          };
        }
    )
    # and ...
    //
    # Attribute from static evaluation
    {
      # Nixpkgs and Home-Manager helpful functions
      lib = nixpkgs.lib // home-manager.lib // uzinfocom-pkgs.lib;

      # Formatter for your nix files, available through 'nix fmt'
      # Other options beside 'alejandra' include 'nixpkgs-fmt'
      inherit (uzinfocom-pkgs) formatter;

      # Reusable nixos modules you might want to export
      # These are usually stuff you would upstream into nixpkgs
      nixosModules = import ./modules/nixos;

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = self.lib.config.attrSystem {
        inherit inputs outputs;
        opath = ./.;
        list = [
          #     ____      __                        __
          #    /  _/___  / /____  _________  ____ _/ /
          #    / // __ \/ __/ _ \/ ___/ __ \/ __ `/ /
          #  _/ // / / / /_/  __/ /  / / / / /_/ / /
          # /___/_/ /_/\__/\___/_/  /_/ /_/\__,_/_/
          # Our internal infrastructure for development
          {
            # GitHub Runners, Containers,
            # DNS & Minecraft
            name = "Laboratory";
            alias = "internal/laboratory";
          }

          #     __________           __
          #    / ____/ __/___ ____  / /
          #   / __/ / /_/ __ `/ _ \/ /
          #  / /___/ __/ /_/ /  __/ /
          # /_____/_/  \__,_/\___/_/
          # "Efael" Platform Infrastructure
          {
            # Matrix Synapse & Authentication
            name = "Efael-State";
            alias = "efael/server";
          }

          #    __  __     __
          #   / / / /____/ /_  ____ ______
          #  / / / / ___/ __ \/ __ `/ ___/
          # / /_/ / /__/ / / / /_/ / /
          # \____/\___/_/ /_/\__,_/_/
          # "Uchar" Platform Infrastructure
          {
            # Matrix Synapse & Authentication
            name = "Uchar-State";
            alias = "uchar/server";
          }

          #     ____            __
          #    / __ )___  _____/ /__
          #   / __  / _ \/ ___/ //_/
          #  / /_/ /  __/ /  / ,<
          # /_____/\___/_/  /_/|_|
          # "Berk" Platform Infrastructure
          {
            # Matrix Synapse & Authentication
            name = "Berk-State";
            alias = "berk/server";
          }
          {
            # Livekit
            name = "Berk-Live";
            alias = "berk/live";
          }
          {
            # Livekit behind firewall
            name = "Berk-Live-Firewall";
            alias = "berk/live-firewall";
          }
        ];
      };
    };
}
