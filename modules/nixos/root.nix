{...}:
let
  # keys -> [ { k.username, k.hash } ]
  fetcher = keys: map (k:
    builtins.readFile (
      builtins.fetchurl {
        url = "https://github.com/${k.username}.keys";
        sha256 = k.hash;
      }
    )
  ) keys;
in
{
  config = {
    # To be able to SSH into the system on emergency
    users.users.root.openssh.authorizedKeys.keys =
      fetcher [
        {
          username = "orzklv";
          hash = "05rvkkk382jh84prwp4hafnr3bnawxpkb3w6pgqda2igia2a4865";
        }
        {
          username = "shakhzodkudratov";
          hash = "0gnabwywc19947a3m4702m7ibhxmc5s4zqbhsydb2wq92k6qgh6g";
        }
      ];
  };
}
