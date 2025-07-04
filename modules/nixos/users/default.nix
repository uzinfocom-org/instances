# # Keep all specific user configs here as a module
{
  # List your users here
  kei = import ./kei.nix;
  # this guys works on Efael as well. so thats why we are adding this separatly 
  sakhib = import ./sakhib;
  shakhzod = import ./shakhzod;
  mkUser = import ./mkUser.nix;
}
