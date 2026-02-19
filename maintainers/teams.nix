{ lib }:
let
  members = lib.umembers or import ./members.nix { inherit lib; };
in
{
  leads = {
    members = with members; [
      orzklv
      bahrom04
    ];
    scope = "Lead position members of Uzinfocom Open Source.";
  };

  admins = {
    members = with members; [
      aekinskjaldi
    ];
    scope = "Datacenter administrators from our team + dc.uz.";
  };

  xinux = {
    members = with members; [
      bahrom04 # Maintainer
      bemeritus
      rafanochi
      akmal

      letrec # Maintainer
      lambdajon
    ];
    scope = "Developers and maintainers of Xinux project.";
  };

  uchar = {
    members = with members; [
      sud0pacman # Maintainer
    ];
    scope = "Developers and maintainers of Efael project.";
  };
}
