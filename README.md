# vscodaemon
`vscodaemon` provides daemon-service features to [code-server](https://github.com/cdr/code-server).

This enables `code-server` to:
- Run in background
- Respond to start, stop, restart and status as a system service
- Be configured (e.g. application user, port) on installation
- Be re-configured (e.g. port, work directory) any time

## Quick install
```sh
wget -qO- https://raw.githubusercontent.com/aielo/vscodaemon/master/vscodaemon.sh | bash -s install
```
<sub>**Note:** this installs `vscodaemon` with default settings, i.e., `code-server` port and password remain unchanged. Remember to either use the available [options](#Usage) or setup your `~/.code-server` file later.</sub>

## The \[un\]install script
It can be used to either install or uninstall both `vscodaemon` and `code-server`.
```sh
./vscodaemon.sh (install|uninstall) [OPTIONS]
```

## Install options

The following parameters can be used during installation:

| Option            | Option (full)            | Description                      | Default           |
| :---              | :---                     | :---                             | :---:             |
| -g                | --group                  | OS `USER` group                  | `USER`            |
| -i                | --install-dir            | `code-server` version            | /opt/code-server  |
| -p                | --password               | Password for VS Code web access  | `USER`            |
| -P                | --port                   | HTTP port for VS Code web access | 8443              |
| -s                | --grant-sudo             | `sudo` permissions to user       | NO                |
| -u                | --user                   | OS `USER`                        | coder             |
| -v                | --version                | `code-server` version            | [Lastest version](https://github.com/cdr/code-server/releases/latest) |
| -w                | --work-dir               | Working (start) directory        | `USER`'s home     |

<sub>**Note:** other `code-server` parameters are not currently supported.</sub>

## The daemon
Daemon supports `start`, `stop`, `restart` and `status` operations.
```sh
service code-server restart
```
