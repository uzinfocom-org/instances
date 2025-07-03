{
  pkgs,
  inputs,
  config,
  ...
}: let
  homeModules = inputs.bahrom04.homeModules;
in {
  imports = [
    homeModules.nixpkgs
    homeModules.direnv
    homeModules.home.fastfetch
    homeModules.home.fish
    homeModules.home.git
    homeModules.home.starship
    homeModules.home.zsh
  ];

  home.username = "bahrom04";
  home.homeDirectory = "/home/bahrom04";

  home.packages = with pkgs; [
    git
    gnupg # gpg key uchun
    neofetch
    # others
    file
    which
    tree
    # nix-output-monitor
    btop
  ];

  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
  # home-manager.backupFileExtension = "backup";
}
