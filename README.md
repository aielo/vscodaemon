# vscodaemon
`vscodaemon` provides daemon-service features to [code-server](https://github.com/cdr/code-server).

This enables `code-server` to:
- Run in background
- Respond to start, stop, restart and status as a system service
- Be configured (e.g. application user, port) on installation
- Be re-configured (e.g. port, work directory) any time

## Install on Ubuntu/Debian
```sh
wget -qO- https://raw.githubusercontent.com/aielo/vscodaemon/master/install-debian.sh | bash
```
<sub>**Note:** this installs `vscodaemon` with default settings, i.e., `code-server` port and password remain unchanged. Remember to either set/change variables in the script prior running or setup new values right after the installation.</sub>
