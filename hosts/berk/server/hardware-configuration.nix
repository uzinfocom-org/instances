{
  inputs,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    # Disko partitioning
    inputs.disko.nixosModules.disko
    ./disk-configuration.nix

    # Not available hardware modules
    (modulesPath + "/installer/scan/not-detected.nix")

    # QEMU Guest profile
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  # Bootloader shits
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
        address = "10.0.0.102";
        gateway = "10.0.0.211";
      };
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
