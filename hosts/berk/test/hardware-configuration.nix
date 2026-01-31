{
  inputs,
  outputs,
  lib,
  config,
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
        subnet = 28;
        address = "45.150.26.120";
        gateway = "45.150.26.117";
      };
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
