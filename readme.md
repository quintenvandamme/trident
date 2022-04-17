# Trident
The magic kernel manager for ubuntu based distros and WSL2.

![latest-release](https://img.shields.io/github/v/release/quintenvandamme/trident) ![latest-prerelease](https://img.shields.io/github/v/tag/quintenvandamme/trident?include_prereleases)

![terminal](assets/screenshots/light.svg#gh-dark-mode-only)
![terminal](assets/screenshots/dark.svg#gh-light-mode-only)


## Install

```sudo mkdir /var/cache/trident/ && sudo chmod 777 /var/cache/trident/ && sudo wget https://github.com/quintenvandamme/trident/releases/download/0.0.4/trident -P /usr/bin/ && sudo chmod +x /usr/bin/trident```

## Usage

| command               | description                                  |
|-----------------------|----------------------------------------------|
| --version             | display version.                             |
| -help                 | list all commands.                           |
| -update               | check for and install updates.               |
| -install **[kernel]** | install specific kernel from binary.         |
| -compile **[kernel]** | build and install specific kernel.           |
| -wsl **[kernel]**     | build and install specific kernel for wsl2.  |

You can replace **[kernel]** with:
- a specific kernel version like 5.16.2 or 5.17-rc5
- latest_rc
- latest_mainline
- latest_lts

## TODO

- [x] Add Generic Linux support (X86_64 and arm64)
- [x] Add WSL2 support (X86_64 and arm64)
- [ ] Add RaspberryPi support (arm and arm64)
- [ ] Add WSA support (X86_64 and arm64)
- [ ] Add SteamDeck support (Linux 5.18?)
- [ ] Add m1 support => Add support for arch linux.

## License
##### **license template made by brutal-org**

<a href="https://opensource.org/licenses/MIT">
  <img align="right" height="96" alt="MIT License" src="assets/license/mit-license.png" />
</a>

Trident and its components are licensed under the **MIT License**.

The full text of the license can be accessed via [this link](https://opensource.org/licenses/MIT) and is also included in the [license](license) file of this software package.

