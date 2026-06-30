# Selkies Fresh Instance Setup: LaaS Developer Environment Guide

This guide details the step-by-step commands to configure your development environment on a Selkies container instance. By completing this setup, your tools and database storage will persist across container restarts.

---

## 1. Install Antigravity IDE (Persistent)

### 1.1. Download IDE
Download the **Antigravity IDE Linux `.tar.gz`** package using Firefox. 

By default, it will download to:
```
~/Downloads/Antigravity IDE.tar.gz
```

### 1.2. Extract into persistent Apps directory
Run the following commands to create a persistent application directory and extract the IDE:

```bash
mkdir -p ~/Apps

tar -xzf "$HOME/Downloads/Antigravity IDE.tar.gz" -C "$HOME/Apps"

mv "$HOME/Apps/Antigravity IDE" "$HOME/Apps/Antigravity"
```

### 1.3. Start Antigravity
Since Selkies is a containerized environment, you must always launch the IDE with the `--no-sandbox` flag:

```bash
~/Apps/Antigravity/antigravity --no-sandbox
```

---

## 2. Configure Firefox as Default Browser

Antigravity IDE handles Google OAuth login requests using the system-wide URL opener (`xdg-open`). You must configure Firefox as the default handler to prevent authentication issues.

### 2.1. Set Firefox as Default
Run these commands to map HTTP/HTTPS protocols to Firefox:

```bash
xdg-settings set default-web-browser firefox.desktop

xdg-mime default firefox.desktop x-scheme-handler/http

xdg-mime default firefox.desktop x-scheme-handler/https
```

### 2.2. Verify Configuration
Check that the bindings were saved successfully:

```bash
xdg-settings get default-web-browser

xdg-mime query default x-scheme-handler/http

xdg-mime query default x-scheme-handler/https
```

**Expected Output:**
```
firefox.desktop
firefox.desktop
firefox.desktop
```

### 2.3. Test Link Redirection
Verify that URLs open correctly inside Firefox:

```bash
xdg-open https://accounts.google.com
```

---

## 3. Install and Configure PostgreSQL (Persistent)

Since standard containers lack background system managers like `systemd`, we will manually set up a persistent database cluster under your home directory.

### 3.1. Install PostgreSQL Binaries
Install version 16 from the standard package repositories:

```bash
sudo apt update

sudo apt install postgresql-16
```

### 3.2. Copy Binaries to Persistent Storage
Copy the binary execution directory to a persistent folder so it doesn't get wiped on restart:

```bash
mkdir -p ~/Apps/PostgreSQL

cp -r /usr/lib/postgresql/16/* ~/Apps/PostgreSQL/
```

### 3.3. Initialize Database Cluster Directories
Create separate persistent directories for data cluster storage, logs, and socket runtimes:

```bash
mkdir -p ~/Postgres/data
mkdir -p ~/Postgres/logs
mkdir -p ~/Postgres/run
```

Initialize the database files in your newly created directory:

```bash
~/Apps/PostgreSQL/bin/initdb -D ~/Postgres/data
```

### 3.4. Reconfigure Unix Sockets
Configure the database cluster to write its runtime Unix sockets under your home directory instead of the restricted `/var/run/postgresql`:

```bash
sed -i "s|^#\?unix_socket_directories.*|unix_socket_directories = '/home/ubuntu/Postgres/run'|" ~/Postgres/data/postgresql.conf
```

### 3.5. Create Startup Script
Create a startup helper script to automate setting up paths and launching the database background process:

```bash
nano ~/Postgres/start.sh
```

Paste the following script content:

```bash
#!/bin/bash

export PATH="$HOME/Apps/PostgreSQL/bin:$PATH"

mkdir -p "$HOME/Postgres/logs"
mkdir -p "$HOME/Postgres/run"

pg_ctl \
-D "$HOME/Postgres/data" \
-l "$HOME/Postgres/logs/postgres.log" \
start
```

Make the script executable:

```bash
chmod +x ~/Postgres/start.sh
```

### 3.6. Create Stop Script
Create a stop helper script to safely shut down the database engine:

```bash
nano ~/Postgres/stop.sh
```

Paste the following script content:

```bash
#!/bin/bash

export PATH="$HOME/Apps/PostgreSQL/bin:$PATH"

pg_ctl \
-D "$HOME/Postgres/data" \
stop
```

Make the script executable:

```bash
chmod +x ~/Postgres/stop.sh
```

### 3.7. Run Your Custom PostgreSQL Instance
Stop the temporary instance automatically created by the system package manager during installation:

```bash
sudo pg_ctlcluster 16 main stop
```

Start your custom database instance using the startup helper:

```bash
~/Postgres/start.sh
```

### 3.8. Create Database and Superuser Role
Connect to the database engine using the temporary Unix socket directory:

```bash
~/Apps/PostgreSQL/bin/psql \
-h ~/Postgres/run \
postgres
```

Run these SQL commands to initialize the default `postgres` superuser role and create the application database `laas`:

```sql
CREATE ROLE postgres WITH LOGIN SUPERUSER PASSWORD 'root';

CREATE DATABASE laas;

\q
```

### 3.9. Test Connection String
Verify you can connect to the database via TCP/IP loopback:

```bash
psql "postgresql://postgres:root@localhost:5432/laas"
```

**Expected Console Prompt:**
```
laas=#
```

---

## 4. Anaconda Python Environment Setup

Configure a lightweight Python runtime environment to install project dependencies.

### 4.1. Download and Install Miniconda
Download the official Miniconda installer package:

```bash
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /home/ubuntu/miniconda.sh
```

Execute the installer and configure it to write to your persistent home directory path:

```bash
bash /home/ubuntu/miniconda.sh -b -p /home/ubuntu/miniconda3
```

Clean up the setup file:

```bash
rm /home/ubuntu/miniconda.sh
```

### 4.2. Initialize Conda Shell Settings
Bind the Conda executable settings into your shell environment:

```bash
/home/ubuntu/miniconda3/bin/conda init bash

source /home/ubuntu/.bashrc
```

Verify the installation succeeded:

```bash
conda --version
```

### 4.3. Set Up a Project Conda Environment
Create a dedicated Python 3.11 environment and install PyTorch with GPU compatibility support:

```bash
conda create -n torch-env python=3.11 -y

conda activate torch-env

pip install torch --index-url https://download.pytorch.org/whl/cu128 -q
```

Verify GPU acceleration availability:

```bash
python3 -c "import torch; print(torch.__version__); print(torch.cuda.is_available())"
```

---

## 5. Daily Development Workflow

When starting a fresh container session, run these commands to restore your workspace.

### 5.1. Start Database Server
```bash
~/Postgres/start.sh
```

### 5.2. Connect to Database (Console)
```bash
psql "postgresql://postgres:root@localhost:5432/laas"
```

To run a query directly:
```bash
psql "postgresql://postgres:root@localhost:5432/laas" -c "SELECT * FROM users;"
```

### 5.3. Launch Antigravity IDE
```bash
~/Apps/Antigravity/antigravity --no-sandbox
```

---

## 6. Directory Layout Reference

Ensure your directories are configured as follows:

```
/home/ubuntu
│
├── Apps
│   ├── Antigravity
│   └── PostgreSQL
│
└── Postgres
    ├── data      (all databases)
    ├── logs
    ├── run
    ├── start.sh
    └── stop.sh
```

---

## 7. Verification Checklist

*   ✅ Antigravity IDE persists across new containers.
*   ✅ Google OAuth redirect flow succeeds via Firefox.
*   ✅ PostgreSQL binaries persist.
*   ✅ PostgreSQL databases persist.
*   ✅ PostgreSQL is accessible on `localhost:5432`.
*   ✅ Works without requiring `systemd`.
*   ✅ Spawning a new container preserves your entire workspace storage.
