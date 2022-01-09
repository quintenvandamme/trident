#! /usr/bin/env bash

sudo mkdir /var/cache/trident/
sudo chown $USER:$USER /var/cache/trident/
wget https://github.com/quintenvandamme/trident/releases/download/0.0.3-rc3/trident -P /usr/bin/
sudo chmod +x /usr/bin/trident