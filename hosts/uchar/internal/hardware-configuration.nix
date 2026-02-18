{
  inputs,
  outputs,
  lib,
  config,
  modulesPath,
  ...
}:
{
  imports = [
    inputs.disko.nixosModules.disko
    ./disk-configuration.nix

    # Not available hardware modules
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Bootloader shits
  boot = {
    initrd = {
      kernelModules = [
        "nvme"
        "kvm-intel"
        "smartpqi"
      ];
      availableKernelModules = [
        "uhci_hcd"
        "ehci_pci"
        "xhci_pci"
        "ata_piix"
        "hpilo"
        "usbhid"
        "usb_storage"
        "sd_mod"
        "sr_mod"
      ];
    };
  };

  hardware = {
    # Additional configs for Smart Array
    raid.HPSmartArray.enable = true;

    # Microcode
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };

  uzinfocom = {
    boot.uefi = true;
    network = {
      interface = "eno1";
      ipv4 = {
        subnet = 26;
        address = "91.212.89.25";
        gateway = "91.212.89.1";
      };
    };

  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
