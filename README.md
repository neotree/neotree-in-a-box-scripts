# Before running the commands below, make the `deploy` folder executable:
```bash
chmod -R +x deploy
```

# neotree-in-a-box-scripts

Deployment helper scripts for the Neotree stack. Each component has a self-contained deployer under `deploy/` and a shared logging/checks library in `deploy/lib/`.

## Components
- **node-api**: Express/Node back end and PostgreSQL schema.
- **webeditor**: Front-end editor UI that talks to node-api.
- **datapipeline**: Kedro-based data pipeline; auto-creates `conf/local/database.ini` and `conf/local/hospitals.ini` on first run with sensible defaults and optional webeditor integration.
- **metabase**: Analytics layer with its own PostgreSQL application database; now phased deploy with optional nginx + TLS setup.

The stack shares one PostgreSQL role, `neotree_app`, whose credentials live in the app-root `.env` at `~/neotree/.env`. The file is generated on first core database setup and is not tracked by git.

## Prerequisites
- Ubuntu/Debian with sudo access
- git, curl, bash
- Node.js and npm
- PostgreSQL server and client (`psql`)
- Python 3.8 with `python3.8-venv` (datapipeline is pinned to 3.8)

Each deploy script will offer to install missing tools (uses `sudo apt`).

## Quick start (full stack)
```bash
bash deploy/deploy.sh
```
- Runs node-api, webeditor, datapipeline, then metabase.
- Logs per component are written to `deploy/<component>/logs/deploy_YYYYMMDD_HHMMSS.log`.
- Progress is saved under `deploy/state/`. Re-running `deploy/deploy.sh` resumes from the next unfinished phase/component instead of restarting completed work.
- Set `FORCE_DEPLOY=1` to clear saved progress for the components you rerun and execute them from scratch.

## Run a single component
```bash
bash deploy/node-api/deploy.sh
bash deploy/webeditor/deploy.sh
bash deploy/datapipeline/deploy.sh
bash deploy/metabase/deploy.sh
```

## Full cleanup
```bash
bash sensitive/undeploy.sh
```
- Removes the Neotree app tree at `~/neotree`, deploy progress state, Metabase service files, nginx configs/certs, PM2 state, and the system packages installed by these deployers.
- The script is destructive by design and asks for confirmation before removing packages and directories.

## Datapipeline config flow
- Database setup is streamlined for non-technical installs. The deploy creates one shared PostgreSQL user, `neotree_app`, and component databases with app-name defaults: `node_api`, `webeditor`, `datapipeline`, and `metabase`.
- Node API and Webeditor core setup no longer prompt for database host, port, database name, username, password, application URLs, API key, or generated secrets. Shared PostgreSQL credentials are written to `~/neotree/.env`; `NEXTAUTH_SECRET` and `JWT_SECRET` are generated automatically when the advanced step is used.
- After cloning, `deploy/datapipeline/phases/03_config_setup.sh` ensures `conf/local/database.ini` and `conf/local/hospitals.ini` exist.
- Datapipeline defaults: host `localhost`; database `datapipeline`; user `neotree_app`; password loaded from the shared app-root `.env` when available; country `zimbabwe` (can choose `malawi`); `data_fix` `True`.
- If a webeditor connection is desired, the script appends `[webeditor]` with `webeditor` URL and `webeditor_api_key`.
- Existing ini files are backed up with timestamped `.bak_*` before overwrite.

### Python 3.8 on Ubuntu 24.04
Ubuntu 24 ships Python 3.12 by default. The datapipeline scripts install/use Python 3.8 via deadsnakes:
```bash
sudo apt install -y software-properties-common
sudo add-apt-repository -y ppa:deadsnakes/ppa
sudo apt update
sudo apt install -y python3.8 python3.8-venv python3.8-distutils
```
The deployer uses `python3.8` explicitly (overridable with `PYTHON_BIN`).

## Environment overrides (advanced)
You can override locations or repo sources via env vars before running a script, e.g.:
```bash
APP_ROOT=$HOME/neotree-test UPDATE_REPO=1 bash deploy/datapipeline/deploy.sh
DATAPIPELINE_REPO=https://github.com/yourfork/datapipeline.git bash deploy/datapipeline/deploy.sh
PYTHON_BIN=python3.8 bash deploy/datapipeline/deploy.sh
```

## Metabase domain, nginx, and certificates
- The Metabase deployer now asks whether to continue into advanced setup after the core application is ready. If you continue, it asks for a domain; leaving it blank auto-detects the server’s public IP and uses that in nginx.
- nginx reverse-proxy is created at `/etc/nginx/sites-available/metabase.conf` and enabled automatically.
- TLS: you can point the prompts to existing cert files (fullchain and key). They will be copied to `/etc/ssl/neotree/metabase.crt` and `/etc/ssl/neotree/metabase.key` with secure perms, then nginx is reloaded. Skip TLS to run on plain HTTP.

## Node API & Webeditor domains/TLS
- Their nginx and mail configuration now live behind an opt-in advanced setup step. If you continue, you’re prompted for mail settings and then for a domain (blank → auto-detected public IP), optionally followed by cert/key paths. Certs are staged under `/etc/ssl/neotree/<site>.crt/.key`; nginx is tested and reloaded automatically. Skip advanced setup to run the apps without mail or reverse proxy.

### Certificate prep tips (all apps)
- If you already have certs from a CA (including Let’s Encrypt), copy the fullchain and key files to the server first (e.g., `scp fullchain.pem user@server:/tmp/` and `scp privkey.pem user@server:/tmp/`).
- During deploy, when prompted for TLS, point to those paths; the scripts will copy them into `/etc/ssl/neotree/` with safe permissions.
- If you skip TLS during deploy, you can re-run the nginx phase later (e.g., `bash deploy/node-api/phases/08_nginx_setup.sh`) to add HTTPS without redeploying everything.

### Domain fallback logic
- Each nginx setup asks for a domain. If left blank, it auto-detects the server’s public IPv4 and uses that in the config.
- You can override server names by rerunning just the nginx phase for each component with the desired domain.

### Phase-only reruns
- Node API advanced setup: `bash deploy/node-api/phases/09_advanced_setup.sh`
- Webeditor advanced setup: `bash deploy/webeditor/phases/09_advanced_setup.sh`
- Node API nginx only: `bash deploy/node-api/phases/08_nginx_setup.sh`
- Webeditor nginx only: `bash deploy/webeditor/phases/08_nginx_setup.sh`
- Metabase nginx only: `bash deploy/metabase/phases/04_nginx_setup.sh`

### Defaults and overrides quick sheet
- Domain prompt blank ⇒ uses detected public IP.
- TLS prompt skip ⇒ plain HTTP on port 80.
- Cert/key staged under `/etc/ssl/neotree/` named per site (e.g., `neotree-node-api.crt`).
- Environment knobs: `NGINX_SITE_NAME`, `NGINX_SERVER_NAME`, `SKIP_NGINX_SETUP=1` (to bypass), `MB_PORT`, `APP_ROOT`, `NODE_ENV_FILE`, `PYTHON_BIN` (datapipeline), `DATAPIPELINE_REPO`, `DATAPIPELINE_BRANCH`, `UPDATE_REPO=1`.

## Troubleshooting
- Check the latest log file under each component’s `deploy/logs/` directory.
- Re-run with `AUTO_YES=1` for non-interactive defaults if needed.
