# reference: https://www.reddit.com/r/NixOS/comments/17a46oh/does_nix_support_defining_attr_schemas_or_types/
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
} @ upstream: let
  users = [
    {
      username = "sakhib";
      hashedPassword = lib.strings.concatStrings [
        "$y$j9T$dsXOFHW"
        "CyplfRPiwsKu0l"
        "0$7YXPRLohyW8Q"
        "XfyITPP6Sag/l7"
        "XH3i7TO4uGByPK"
        "Bb2"
      ];
      description = "Sokhibjon Orzikulov";
      githubKeysUrl = "https://github.com/orzklv.keys";
      sha256 = "05rvkkk382jh84prwp4hafnr3bnawxpkb3w6pgqda2igia2a4865";
      homeModules = with inputs.orzklv.homeModules; [
        git
        zsh
        helix
        topgrade
        packages
        fastfetch
      ];
    }
    {
      username = "shakhzod";
      hashedPassword = lib.strings.concatStrings [
        "$y$j9T$mi9V."
        "JCa4o3.QO2X2"
        "8vJo1$KzXKjk"
        "/5sN4lbsvF8B"
        "IEIwhKCL34e0"
        "gJxZEe.MMoT1"
        "B"
      ];
      description = "Shakhzod Kudratov";
      githubKeysUrl = "https://github.com/shakhzodkudratov.keys";
      sha256 = "0gnabwywc19947a3m4702m7ibhxmc5s4zqbhsydb2wq92k6qgh6g";
      homeModules = with inputs.orzklv.homeModules; [
        git
        zsh
        helix
        topgrade
        packages
        fastfetch
      ];
    }
    {
      username = "bahrom04";
      hashedPassword = "$y$j9T$PEPMAZlXHzgRwOlum.4JA0$sh0uNM1PxrWmSjRdjYkw2iiDdquWF3z9CDAaasEwQ88";
      description = "Baxrom Raxmatov";
      githubKeysUrl = "https://github.com/bahrom04.keys";
      sha256 = "1yc88pr5dj8z9d2kdrlx9r10jpdkaygbmc932z0dkbz3n1lgdcq0";
      homeModules = with inputs.bahrom04.homeModules; [
        direnv
        home.fastfetch
        home.fish
        home.git
        home.starship
        home.zsh
      ];
    }
    {
      username = "letrec";
      hashedPassword = lib.strings.concatStrings [
        "$y$j9T$1TztZ"
        "x5c5Lp/QBhTf"
        "OffV1$RRY6mz"
        "6LNHoXtLNGVh"
        "igy2cu3XTeBu"
        "8GQrBewDr0oZD"
      ];
      description = "Hamidulloh Toʻxtayev";
      githubKeysUrl = "https://github.com/let-rec.keys";
      sha256 = "19yg67mljcy7a730i4ndvcb1dkqcvp0ccyggrs0qqvza5byliifg";
      homeModules = with inputs.letrec.homeModules; [
        git
        zsh
      ];
    }
    {
      username = "bemeritus";
      hashedPassword = "$y$j9T$G5x83.b0sXlsIFrdJvyQ5/$g.Rxw2YsfD4YzEVjNTyfCJWr/qpD.6kWFJECOzyFTg6";
      description = "BeMeritus";
      githubKeysUrl = "https://github.com/bemeritus.keys";
      sha256 = "0dr30cmzbiz192xfjfbb26sk9ynpwfla53q09hx6mr404rdszy9a";
      homeModules = with inputs.bemeritus.homeModules; [
        git
        starship
      ];
    }
    {
      username = "domirando";
      hashedPassword = lib.strings.concatStrings [
        "$y$j9T$7uoELFRD8t70X8IiTMHn/.$QQt5GT21792Vr5BpL53rY1fFQw2iOJ95MYlZRvvDU74"
      ];
      description = "Maftuna Vohidjonovna";
      githubKeysUrl = "https://github.com/domirando.keys";
      sha256 = "0pd2bv95w9yv7vb3vn5qa1s3w1yc7b68qd5xbm8c6y7hmnhckygl";
      homeModules = with inputs.domirando.homeModules; [
        git
        bash
        zellij
      ];
    }
  ];
in {
  config = outputs.lib.users.mkUsers users upstream;
}
