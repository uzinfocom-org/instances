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

    # Orzklv's Nix configuration
    orzklv = {
      url = "github:orzklv/nix/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Uzinfocom's packages repository
    uzinfocom-pkgs = {
      url = "github:uzinfocom-org/pkgs";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-unstable.follows = "nixpkgs-unstable";
      };
    };
  };

  outputs = {     self,
  nixpkgs,
  home-manager,
  flake-utils,
  orzklv,
  uzinfocom-pkgs,
  ...
 } @ inputs : let
 # Self instance pointer
 outputs = self;
 in
 # Attributes for each system
 flake-utils.lib.eachDefaultSystem (
   system: let
     # Packages for the current <arch>
     pkgs = nixpkgs.legacyPackages.${system};
   in
     # Nixpkgs packages for the current system
     {
       # Development shells
       devShells.default = import ./shell.nix {inherit pkgs;};
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

   # Your custom packages and modifications, exported as overlays
   overlays = import ./overlays {inherit inputs;};

   # Reusable nixos modules you might want to export
   # These are usually stuff you would upstream into nixpkgs
   nixosModules = import ./modules/nixos;

   # NixOS configuration entrypoint
   # Available through 'nixos-rebuild --flake .#your-hostname'
   nixosConfigurations = self.lib.config.mapSystem {
     inherit inputs outputs;
     opath = ./.;
     list = [
       "Efael"
     ];
   };
 };
}
