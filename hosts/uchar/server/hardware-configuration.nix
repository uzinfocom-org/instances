{
  config,
  inputs,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    inputs.disko.nixosModules.disko
    ./disk-configuration.nix

    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Bootloader shits
  boot = {
    initrd = {
      availableKernelModules = [
        "ata_piix"
        "mptspi"
        "uhci_hcd"
        "ehci_pci"
        "sd_mod"
        "sr_mod"
      ];
    };
  };

  uzinfocom = {
    network = {
      interface = "ens160";
      ipv4.address = "10.103.7.200";
      nameservers = ["195.158.0.1"];
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
