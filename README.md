# trident
The magic kernel manager for elementary os and ubuntu based distros.

# testing

- Make a cache directory for trident in /var/cache/
```sudo mkdir /var/cache/trident/;sudo chown user:user /var/cache/trident/```
- Get dependencies and run trident.
```dart pub get```
```dart bin/main.dart --install <kernel>```


For help run `dart bin/main.dart --help`