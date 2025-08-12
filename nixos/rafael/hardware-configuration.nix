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

  # Use DHCP (router will handle static behaviour)
  networking.useDHCP = lib.mkDefault true;

  # Platform specific configurations
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
