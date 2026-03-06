{
  inputs,
  outputs,
  lib,
  modulesPath,
  ...
}:
{
  imports = [
    # Disko partitioning
    inputs.disko.nixosModules.disko
    ./disk-configuration.nix

    # Not available hardware modules
    (modulesPath + "/installer/scan/not-detected.nix")

    # Virtualization environment
    outputs.nixosModules.kvm
  ];

  # Bootloader shits
  boot = {
    initrd = {
      availableKernelModules = [
        "ata_piix"
        "vmw_pvscsi"
        "ahci"
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
    kvm = {
      enable = true;
      type = "vmware";
    };
    network = {
      interface = "ens33";
      ipv4 = {
        address = "192.168.20.32";
        gateway = "192.168.20.70";
      };
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
