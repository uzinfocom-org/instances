{
  outputs,
  config,
  pkgs,
  ...
}: {
  home.username = "domirando";
  home.homeDirectory = "/home/domirando";
  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 172;
  };
  home.packages = with pkgs; [
    neofetch
    nnn
    cargo
    gcc
    #archives
    zip
    nixfmt-rfc-style
    p7zip
    unzip
    xz
    alejandra
    #utils
    ripgrep
    jq
    eza
    fzf
    ghostty

    file
    which

    glow

    fractal
    telegram-desktop

    nodejs_24
    zellij
    neovim
  ];
  programs.git = {
    enable = true;
    userName = "Domirando";
    userEmail = "vohidjonovnamaftuna@gmail.com";
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
          	export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
      export PATH="$PATH:/usr/local/bin/espanso"

    '';
    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake . --show-trace";
    };
    initExtra = ''
      export PS1='\[\e[38;5;189m\]\u\[\e[0m\] \[\e[38;5;153m\]in \[\e[38;5;129m\]\W\[\e[38;5;46m\]\$\[\e[0m\] '
	eval "$(zellij setup --generate-auto-start bash)"
    '';
  };
  home.stateVersion = "25.05";
}
