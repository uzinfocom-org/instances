{
  pkgs ? let
    lock = (builtins.fromJSON (builtins.readFile ./flake.lock)).nodes.nixpkgs.locked;
    nixpkgs = fetchTarball {
      url = "https://github.com/nixos/nixpkgs/archive/${lock.rev}.tar.gz";
      sha256 = lock.narHash;
    };
  in
    import nixpkgs {overlays = [];},
  pre-commit-check,
  ...
}:
pkgs.stdenv.mkDerivation {
  name = "instances";

  # Build time dependencies
  nativeBuildInputs = with pkgs; [
    git
    nixd
    sops
    statix
    deadnix
    alejandra

    # VPN Stuff
    easyrsa
    openssl
  ];

  # Runtime dependencies
  buildInputs = pre-commit-check.enabledPackages;

  # Things to run before entering devShell
  shellHook = ''
    ${pre-commit-check.shellHook}
  '';

  # Environmental variables
  NIX_CONFIG = "extra-experimental-features = nix-command flakes";
}
