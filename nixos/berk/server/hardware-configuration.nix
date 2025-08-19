{
  config,
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
    kernelModules = [];
    extraModulePackages = [];

    initrd = {
      kernelModules = [];
      availableKernelModules = [
        "ata_piix"
        "uhci_hcd"
        "virtio_pci"
        "virtio_scsi"
        "sd_mod"
        "sr_mod"
      ];
    };

    bios = {
      enable = true;
      uefi = true;
    };
  };

  # Nawww, we going static!
  networking = {
    interfaces = {
      ens18.ipv4.addresses = [
        {
          address = "45.150.26.120";
          prefixLength = 28;
        }
      ];
    };
    defaultGateway = {
      address = "45.150.26.113";
      interface = "ens18";
    };

    nameservers = [
      "8.8.8.8"
    ];
  };

  # Platform specific configurations
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
