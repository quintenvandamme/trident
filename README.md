# trident
The magic kernel manager for ubuntu based distros and WSL2.

![latest-release](https://img.shields.io/github/v/release/quintenvandamme/trident) ![latest-prerelease](https://img.shields.io/github/v/tag/quintenvandamme/trident?include_prereleases)

![terminal](assets/screenshots/light.svg#gh-dark-mode-only)
![terminal](assets/screenshots/dark.svg#gh-light-mode-only)


## install

```sudo mkdir /var/cache/trident/ && sudo chown $USER:$USER /var/cache/trident/ && sudo wget https://github.com/quintenvandamme/trident/releases/download/0.0.4-rc1/trident -P /usr/bin/ && sudo chmod +x /usr/bin/trident```

## usage

| command               | description                                  |
|-----------------------|----------------------------------------------|
| --version             | display version.                             |
| -help                 | list all commands.                           |
| -install **[kernel]** | install specific kernel from binary.         |
| -compile **[kernel]** | build and install specific kernel.           |
| -wsl **[kernel]**     | build and install specific kernel for wsl2.  |
| -catalog **[kernel]** | catalog specific kernel.                     |

You can replace **[kernel]** with:
- a specific kernel version like 5.16.2 or 5.17-rc5
- -latest-rc
- -latest-mainline
- -latest-lts