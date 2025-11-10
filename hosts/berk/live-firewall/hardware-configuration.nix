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
        address = "10.0.0.105";
        gateway = "10.0.0.211";
      };
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
