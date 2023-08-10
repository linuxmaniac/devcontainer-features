# Dev Container Features:

This repository contains a _collection_ of Features
### `talosctl`

Running [`talosctl`](https://www.talos.dev/v1.4/learn-more/talosctl/) inside the built container.

Based on the work of [jsburckhardt/devcontainer-features/flux](https://github.com/jsburckhardt/devcontainer-features/)

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/linuxmaniac/devcontainer-features/talosctl:1": {
            "version": "v1.4.7"
        }
    }
}
```

### `ksniff`

[ksniff](https://github.com/eldadru/ksniff) kubectl plugin

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/linuxmaniac/devcontainer-features/ksniff:1": {
            "version": "v1.6.2"
        }
    }
}
```
