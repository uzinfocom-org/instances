{
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    #inputs.letrec.homeModules.bash
    # inputs.letrec.homeModules.vscode
    #inputs.letrec.homeModules.firefox
    #inputs.letrec.homeModules.direnv
    inputs.letrec.homeModules.zsh
    inputs.letrec.homeModules.git
    #inputs.letrec.homeModules.ssh
    #inputs.letrec.homeModules.zed
    #inputs.letrec.homeModules.nixpkgs
    #inputs.letrec.homeModules.packages
    inputs.letrec.homeModules.fastfetch
    inputs.letrec.homeModules.nixpkgs
  ];
  home = {
    stateVersion = "24.11";
    username = "letrec";
    homeDirectory = "/home/letrec";
    enableNixpkgsReleaseCheck = false;
  };

  programs.home-manager.enable = true;
}
