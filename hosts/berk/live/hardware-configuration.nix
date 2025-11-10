{
  inputs,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    inputs.disko.nixosModules.disko
    ./disk-configuration.nix

    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "ata_piix"
        "uhci_hcd"
        "virtio_pci"
        "virtio_scsi"
        "sd_mod"
        "sr_mod"
      ];
    };
  };

  uzinfocom = {
    boot.uefi = true;
    network = {
      interface = "ens18";
      ipv4 = {
        address = "45.150.26.120";
        subnet = 28;
        gateway = "45.150.26.113";
      };
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
