# trident
The magic kernel manager for ubuntu based distros and WSL2.

![latest-release](https://img.shields.io/github/v/release/quintenvandamme/trident) ![latest-prerelease](https://img.shields.io/github/v/tag/quintenvandamme/trident?include_prereleases)

![terminal](assets/screenshots/light.svg#gh-dark-mode-only)
![terminal](assets/screenshots/dark.svg#gh-light-mode-only)


## install

```curl -s https://raw.githubusercontent.com/quintenvandamme/trident/main/install.sh```

## usage

| command               | description                                  |
|-----------------------|----------------------------------------------|
| --version             | display version.                             |
| -help                 | list all commands.                           |
| -install **[kernel]** | install specific kernel from binary.         |
| -compile **[kernel]** | build and install specific kernel.           |
| -wsl **[kernel]**     | build and install specific kernel for wsl2.  |
| -catalog **[kernel]** | catalog specific kernel.                     |