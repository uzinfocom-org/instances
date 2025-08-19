{lib, ...}: {
  # Sometimes, shits need some little direct fixes
  home-manager.users.sakhib = {
    home.file.".local/share/fastfetch" = {
      source = ../../.github/config/fastfetch;
      recursive = true;
    };

    programs.topgrade.settings = {
      # Remove cache cleaninx as it deletes all derivations
      pre_commands = lib.mkForce {};

      # Target configuration link to another
      linux = lib.mkForce {
        nix_arguments = "--flake github:uzinfocom-org/instances --option tarball-ttl 0";
      };
    };
  };
}
