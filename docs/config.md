
# config

## general

The config.json file should be stored in ~/.config/trident/

- config.json with all the defaults
```json
{
  "checkforupdates": "true",
  "cron_schedule": "",
  "cron_checkfor": ""
}
```

## options

### checkforupdates
```json
{
  "checkforupdates": "true" // trident will check for updates when you run trident.
}
```

```json
{
  "checkforupdates": "false" // trident won't check for updates when you run trident.
}
```