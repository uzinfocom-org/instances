# Fallback validation point of all modules
{...}: {
  # List all modules here to be included on config
  imports = [
    # Web server & proxy virtual hosts via nginx
    ./www.nix

    # Matrix server hosting
    ./matrix
  ];
}
