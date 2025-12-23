{lib}: let
  members =
    lib.umembers or import ./members.nix {inherit lib;};
in {
  leads = {
    members = with members; [
      orzklv
      shakhzod
    ];
    scope = "Lead position members of Uzinfocom Open Source.";
  };

  admins = {
    members = with members; [
      aekinskjaldi
    ];
    scope = "Datacenter administrators from dc.uz.";
  };

  xinux = {
    members = with members; [
      bahrom04 # Maintainer
      bemeritus
      letrec
    ];
    scope = "Developers and maintainers of Xinux project.";
  };

  uchar = {
    members = with members; [
      shakhzod # Maintainer
    ];
    scope = "Developers and maintainers of Efael project.";
  };
}
