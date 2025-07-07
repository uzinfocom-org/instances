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
  ];
in {
  config = outputs.lib.users.mkUsers users upstream;
}
