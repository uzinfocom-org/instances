<p align="center">
    <img src=".github/assets/header.png" alt="Uzinfocom's {Instances}">
</p>

<p align="center">
    <h3 align="center">Uzinfocom's Infrastructure configurations for all instances.</h3>
</p>

<p align="center">
    <img align="center" src="https://img.shields.io/github/languages/top/uzinfocom-org/instances?style=flat&logo=nixos&logoColor=ffffff&labelColor=242424&color=242424" alt="Top Used Language">
    <a href="https://github.com/uzinfocom-org/instances/actions/workflows/test.yml"><img align="center" src="https://img.shields.io/github/actions/workflow/status/uzinfocom-org/instances/test.yml?style=flat&logo=github&logoColor=ffffff&labelColor=242424&color=242424" alt="Test CI"></a>
</p>

## About

This repository is intended to keep all configurations of instandces ran by Uzinfocom's Open Source Team. Configurations contain both service and environmental implications.

## Features

- Services & Containers
- Rust made replacements
- Key configurations
- Software configurations
- Selfmade scripts

## Get NixOS Ready on your server

This is actually quite hard task as it requires a few prequisites to be prepared beforehand. You may refer to [bootstrap](https://github.com/kolyma-labs/bootstrap) and [installer](https://github.com/kolyma-labs/instances) for further instructions.

## Installing configurations

After you get NixOS running on your machine, the next step is to apply declarative configurations onto your machines:

```shell
sudo nixos-rebuild switch --flake github:uzinfocom-org/instances#Instance --upgrade

# Check keys of users before push. Change hostname (Laboratory) accordingly
nix build .#nixosConfigurations.Laboratory.config.system.build.toplevel --show-trace
```

## Thanks

- [Template](https://github.com/Misterio77/nix-starter-configs) - Started with this template
- [Example](https://github.com/Misterio77/nix-config) - Learned from his configurations
- [Home Manager](https://github.com/nix-community/home-manager) - Simplyifying my life and avoid frustrations
- [Nix](https://nixos.org/) - Masterpiece of package management

## License

This project is licensed under the MIT License - see the [LICENSE](license) file for details.

<p align="center">
    <img src=".github/assets/footer.png" alt="Uzinfocom's {Instances}">
</p>
