{
  inputs,
  config,
  ...
}: {
  imports = [
    inputs.nixos-generators.nixosModules.all-formats
  ];

  # customize an existing format
  formatConfigs.vmware = {config, ...}: {
    services.openssh.enable = true;
  };

  # define a new format
  formatConfigs.iso = {
    config,
    modulesPath,
    ...
  }: {
    imports = ["${toString modulesPath}/installer/cd-dvd/installation-cd-base.nix"];
    formatAttr = "isoImage";
    fileExtension = ".iso";
  };
}
