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

## Custom (environment) variables

The variables below can specified on install and/or at runtime:

| Variable   | Description                      | Default                | On Install | At Runtime |
| :---:      | :---                             | :---:                  | :---:      | :---:      |
| `USER`     | OS user account                  | coder                  | YES        | NO         |
| `PASSWORD` | Password for VS Code web access  | temporary              | YES        | YES        |
| `PORT`     | HTTP port for VS Code web access | 3001                   | YES        | YES        |
| `WORKDIR`  | Starting (working) directory     | /home/`USER`/workspace | YES        | YES        |

<sub>**Note:** other `code-server` parameters are not currently supported.</sub>

### On Install (Ubuntu example)
1. Download the proper `setup-*.sh` script to your distro
```sh
wget https://raw.githubusercontent.com/aielo/vscodaemon/master/install-debian.sh
```
2. Add/set the variables in the beginning of the script
```sh
#!/bin/sh
VERSION=1.1156-vsc1.33.1
USER=myuser
PORT=8000
WORKDIR=/var/www/myproject
[...]
```
3. Run it
```sh
bash install-debian.sh
```

### At Runtime (Ubuntu example)
1. Log into VS Code using default port and password
2. Open a terminal by pressing `` CTRL + SHIFT + ` ``
3. Create the `/home/USER/.code-server/` directory
```sh
mkdir /home/myuser/.code-server
```
4. Create the `.code-server/env` file
```sh
touch /home/USER/.code-server/env
```
5. Edit the `.code-server/env` file and add variables as needed
```sh
PORT=9001
PASSWORD=newpasswd
```
6. Restart the `code-server` service
```sh
sudo service code-server restart
```
