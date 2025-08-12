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

    bios = {
      enable = true;
      # Use if you're going with msdos table
      # devices = ["/dev/sda"];
    };
  };

  # Follow this scheme
  networking = {
    interfaces = {
      ens160.ipv4.addresses = [
        {
          address = "10.103.7.200";
          prefixLength = 24;
        }
      ];
    };
    defaultGateway = {
      address = "10.103.7.1";
      interface = "ens160";
    };

    nameservers = [
      "195.158.0.1"
    ];
  };

  # Platform specific configurations
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
