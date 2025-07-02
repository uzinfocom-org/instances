{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.bemeritus.homeModules.git
    inputs.bemeritus.homeModules.starship
  ];

  # TODO please change the username & home directory to your own
  home.username = "bemeritus";
  home.homeDirectory = "/home/bemeritus";


  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    neofetch
    nnn
    btop
  ];

  home.stateVersion = "25.05";
}
