{
  inputs,
  outputs,
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

    # Virtualization environment
    # outputs.nixosModules.kvm
  ];

  # Bootloader shits
  boot = {
    initrd = {
      kernelModules = [
        "nvme"
        "kvm-intel"
      ];
      availableKernelModules = [
        "uhci_hcd"
        "ehci_pci"
        "ata_piix"
        "hpsa"
        "hpilo"
        "usb_storage"
        "sd_mod"
        "sr_mod"
      ];
    };
  };

  uzinfocom = {
    boot.uefi = true;
    network = {
      interface = "eno1";
      ipv4 = {
        subnet = 28;
        address = "45.150.26.120";
        gateway = "45.150.26.117";
      };
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
