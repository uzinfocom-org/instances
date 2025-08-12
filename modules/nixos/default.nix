# Add your reusable NixOS modules to this directory, on their own file (https://nixos.wiki/ wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{
  # List your module files here
  ssh = import ./ssh.nix;
  zsh = import ./zsh.nix;
  mas = import ./mas.nix;
  users = import ./users;
  web = import ./web.nix;
  root = import ./root.nix;
  maid = import ./maid.nix;
  boot = import ./boot.nix;
  motd = import ./motd.nix;
  data = import ./data.nix;
  images = import ./images.nix;
  secret = import ./secret.nix;
  network = import ./network.nix;
  nixpkgs = import ./nixpkgs.nix;
  container = import ./container.nix;
}
