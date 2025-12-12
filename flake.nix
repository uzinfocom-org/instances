{
  # ===================================================================================================
  # ooooo     ooo             o8o               .o88o.
  # `888'     `8'             `"'               888 `"
  #  888       8    oooooooo oooo  ooo. .oo.   o888oo   .ooooo.   .ooooo.   .ooooo.  ooo. .oo.  .oo.
  #  888       8   d'""7d8P  `888  `888P"Y88b   888    d88' `88b d88' `"Y8 d88' `88b `888P"Y88bP"Y88b
  #  888       8     .d8P'    888   888   888   888    888   888 888       888   888  888   888   888
  #  `88.    .8'   .d8P'  .P  888   888   888   888    888   888 888   .o8 888   888  888   888   888
  #    `YbodP'    d8888888P  o888o o888o o888o o888o   `Y8bod8P' `Y8bod8P' `Y8bod8P' o888o o888o o888o
  # ===================================================================================================
  description = "Configurations for various instances hosted by Uzinfocom Open Source";
  # ===================================================================================================

  # Extra nix configurations to inject to flake scheme
  # => use if something doesn't work out of box or when despaired...
  nixConfig = {
    experimental-features = ["nix-command" "flakes" "pipe-operators"];
    extra-substituters = ["https://cache.xinux.uz/"];
    extra-trusted-public-keys = ["cache.xinux.uz:BXCrtqejFjWzWEB9YuGB7X2MV4ttBur1N8BkwQRdH+0="];
  };

  # inputs are other flakes you use within your own flake, dependencies
  # for your flake, etc.
  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Also see the 'unstable-packages' overlay at 'overlays/home.nix'.

    # Disko
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    # Pre commit hooks for git
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Mail Server
    simple-nixos-mailserver = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-25.05";
      inputs = {
        nixpkgs-25_05.follows = "nixpkgs";
        nixpkgs.follows = "nixpkgs-unstable";
      };
    };

    # Main homepage website
    gate = {
      url = "github:uzinfocom-org/gate";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Matrix sygnal
    sygnal.url = "github:efael/sygnal";
  };

  outputs = {
    self,
    nixpkgs,
    pre-commit-hooks,
    ...
  } @ inputs: let
    # Self instance pointer
    outputs = self;

    # Library from self
    inherit (self) lib;

    # Supported systems for your flake packages, shell, etc.
    systems = [
      "x86_64-linux"
      "aarch64-darwin"
    ];

    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    # Nixpkgs and internal helpful functions
    lib = nixpkgs.lib // import ./lib {inherit (nixpkgs) lib;};

    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};

    # Checks for hooks
    checks = forAllSystems (system: {
      pre-commit-check = pre-commit-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          statix = let
            pkgs = inputs.nixpkgs-unstable.legacyPackages.${system};
          in {
            enable = true;
            package =
              pkgs.statix.overrideAttrs
              (_o: rec {
                src = pkgs.fetchFromGitHub {
                  owner = "oppiliappan";
                  repo = "statix";
                  rev = "43681f0da4bf1cc6ecd487ef0a5c6ad72e3397c7";
                  hash = "sha256-LXvbkO/H+xscQsyHIo/QbNPw2EKqheuNjphdLfIZUv4=";
                };

                cargoDeps = pkgs.rustPlatform.importCargoLock {
                  lockFile = src + "/Cargo.lock";
                  allowBuiltinFetchGit = true;
                };
              });
          };
          alejandra.enable = true;
          flake-checker.enable = true;
        };
      };
    });

    # Formatter for your nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # Development shells
    devShells = forAllSystems (system: {
      default = import ./shell.nix {
        inherit (self.checks.${system}) pre-commit-check;
        pkgs = inputs.nixpkgs-unstable.legacyPackages.${system};
      };
    });

    # Reusable nixos modules you might want to export
    # These are usually stuff you would upstream into nixpkgs
    nixosModules = lib.modifier.autoModules {};

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = lib.hosts.autoConf {inherit inputs outputs;};
  };
}
