{
  config,
  inputs,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    # Not available hardware modules
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Bootloader shits
  boot = {
    kernelModules = [];
    extraModulePackages = [];

    initrd = {
      kernelModules = [];
      availableKernelModules = [
        "ata_piix"
        "mptspi"
        "uhci_hcd"
        "ehci_pci"
        "sd_mod"
        "sr_mod"
      ];
    };

    loader.grub = {
      enable = true;
      device = "/dev/sda";
      useOSProber = true;
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/d348de6d-cff0-41ef-87b5-cadd0259da9a";
    fsType = "ext4";
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/4707ec6f-6ed3-4385-a7f2-b60ac0899366";}
  ];

  # Use DHCP (router will handle static behaviour)
  networking.useDHCP = lib.mkDefault true;

  # Platform specific configurations
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
