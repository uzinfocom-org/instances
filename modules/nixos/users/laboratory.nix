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
      sha256 = "0vb4pj27999zwxm3rczjp3jfy9rqadx1bihbr46yii1v5yfib9g9";
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
      sha256 = "0vsq5vkar6s6rpci0dkvwysv591l4zrwggq8g2y6qimgghk7jwzx";
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
      sha256 = "0m1p3n224c6fwkbiw1p2pzw1wfbq7b3a3i60r81rq5d4nmk8k9m3";
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
      sha256 = "0kvf5vywdvr57rx9w2sjc2fksw7f3afkiqr2j8v6rs2x80pkrpz7";
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
    {
      username = "lambdajon";
      hashedPassword = lib.strings.concatStrings [
        "$6$3JI5jcc8ttUHS3Jg$H/LACxCqw94BvJazHFc/8luEditd10VOe"
        "47FUKfj7.GrJq4Q92kLl0sfEjS1CcBSu4gNnvK7V4MnJtrJogcnm."
      ];
      description = "Lambdajon";
      githubKeysUrl = "https://github.com/lambdajon.keys";
      sha256 = "440dac32fb3ecd060c17f78ad7c34422fefaaccf525c75c3c8dfd5ce86ef516e";
      homeModules = with inputs.lambdajon.homeModules; [
        git
        zsh
        topgrade
        packages
        fastfetch
      ];
    }
  ];
in {
  config = outputs.lib.users.mkUsers users upstream;
}
