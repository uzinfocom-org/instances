{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.letrec.homeModules.starship
    inputs.letrec.homeModules.zsh
    inputs.letrec.homeModules.git
    inputs.letrec.homeModules.packages
    inputs.letrec.homeModules.fastfetch
    inputs.letrec.homeModules.nixpkgs
    #inputs.letrec.homeModules.ssh
  ];
  home = {
    stateVersion = "25.05";
    username = "letrec";
    homeDirectory = "/home/letrec";
    enableNixpkgsReleaseCheck = false;
  };

  programs.home-manager.enable = true;
}
