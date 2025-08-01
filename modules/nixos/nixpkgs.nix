{
  outputs,
  lib,
  config,
  inputs,
  ...
}: {
  config = {
    nixpkgs = {
      # You can add overlays here
      overlays = [
        # Add overlays your own flake exports (from overlays and pkgs dir):
        inputs.uzinfocom-pkgs.overlays.unstable
        inputs.uzinfocom-pkgs.overlays.additions
        inputs.uzinfocom-pkgs.overlays.modifications
        inputs.minecraft.overlay

        # Or define it inline, for example:
        # (final: prev: {
        #   hi = final.hello.overrideAttrs (oldAttrs: {
        #     patches = [ ./change-hello-to-hi.patch ];
        #   });
        # })
      ];
      # Configure your nixpkgs instance
      config = {
        # Disable if you don't want unfree packages
        allowUnfree = true;
        allowUnsupportedSystem = true;
      };
    };

    nix = {
      # This will add each flake input as a registry
      # To make nix3 commands consistent with your flake
      registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

      # This will additionally add your inputs to the system's legacy channels
      # Making legacy nix commands consistent as well, awesome!
      nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

      settings = {
        # Enable flakes and new 'nix' command
        experimental-features = "nix-command flakes";
        # Deduplicate and optimize nix store
        auto-optimise-store = true;
        # Trusted users for secret-key
        trusted-users = [
          "${config.users.users.sakhib.name}"
        ];
        # # Additional servers to fetch binary from
        # substituters = [
        #   "https://cache.xinux.uz/"
        # ];
        # # Keys that packages to be signed with
        # trusted-public-keys = [
        #   "cache.xinux.uz-1:gX2Z53woXiIoLANfcC/Qp7vPPKVdK1sEa8MSiRhjj/M="
        # ];
      };
    };
  };
}
