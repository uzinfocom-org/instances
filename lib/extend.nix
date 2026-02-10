# Just a convenience function that returns the given Nixpkgs standard
# library extended with the Orzklv library.
nixpkgsLib:
let
  mkLib = import ./.;
in
nixpkgsLib.extend (
  self: super: {
    uzinfocom = mkLib { lib = self; };

    # For forward compatibility.
    literalExpression = super.literalExpression or super.literalExample;
    literalDocBook = super.literalDocBook or super.literalExample;
  }
)
