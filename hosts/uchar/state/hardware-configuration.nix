{
  inputs,
  outputs,
  lib,
  modulesPath,
  ...
}: {
  imports = [
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
      kernelModules = [
        "nvme"
        "kvm-intel"
      ];
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usbhid"
      ];
    };
  };

  uzinfocom = {
    boot = {
      uefi = true;
      raided = true;
      mirrors = [
        "/dev/nvme0n1"
        "/dev/nvme1n1"
      ];
    };
    kvm.enable = true;
    network = {
      ipv4.address = "135.181.165.24";
      ipv6.address = "2a01:4f9:3a:1ca2::2";
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
