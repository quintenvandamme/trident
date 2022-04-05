# trident
The magic kernel manager for ubuntu based distros and WSL2.

![latest-release](https://img.shields.io/github/v/release/quintenvandamme/trident) ![latest-prerelease](https://img.shields.io/github/v/tag/quintenvandamme/trident?include_prereleases)

![terminal](assets/screenshots/light.svg#gh-dark-mode-only)
![terminal](assets/screenshots/dark.svg#gh-light-mode-only)


## install

```sudo mkdir /var/cache/trident/ && sudo chmod 777 /var/cache/trident/ && sudo wget https://github.com/quintenvandamme/trident/releases/download/0.0.4-rc7/trident -P /usr/bin/ && sudo chmod +x /usr/bin/trident```

## usage

| command               | description                                  |
|-----------------------|----------------------------------------------|
| --version             | display version.                             |
| -help                 | list all commands.                           |
| -update               | check for and install updates.               |
| -install **[kernel]** | install specific kernel from binary.         |
| -compile **[kernel]** | build and install specific kernel.           |
| -wsl **[kernel]**     | build and install specific kernel for wsl2.  |
| -catalog **[kernel]** | catalog specific kernel.                     |

You can replace **[kernel]** with:
- a specific kernel version like 5.16.2 or 5.17-rc5
- latest_rc
- latest_mainline
- latest_lts

#TODO

- [x] Add Generic Linux support (X86_64 and arm64)
- [x] Add WSL2 support (X86_64 and arm64)
- [ ] Add RaspberryPi support (arm and arm64)
- [ ] Add WSA support (X86_64 and arm64)
- [ ] Add SteamDeck support (Linux 5.18?)
- [ ] Add m1 support => Add support for arch linux.