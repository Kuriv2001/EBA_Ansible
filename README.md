
# EBA Challenge Playbook

## Overview
This Ansible playbook automates the setup of Apache web servers in the `webservers` group, installs required packages, configures authentication for a specific server, and ensures the web service is running with updated configurations. It is designed to be run against a list of servers with Apache installed and configured to serve content from a templated file, and enable password-protected access on one specific server.

## Prerequisites
- **Ansible version**: Ensure you are using **Ansible 2.16**.
- **Inventory**: Run the `setupInventory.sh` script to generate the required inventory file (`inventory.ini`).
- **Authentication**: You will need to provide SSH access credentials for the `root` user (default password: `root`), as the playbook is intended to be run with password-based authentication.

## How to Run

0. **Run the docker compuse**:
   Before running the playbook, execute the docker compose:
   ```bash
   docker compose up -d
   ```

1. **Run the Inventory Setup Script**:
   Before running the playbook, execute the inventory setup script:
   ```bash
   ./setupInventory.sh
   ```

2. **Run the Playbook**:
   Use the following command to execute the playbook:
   ```bash
   ansible-playbook -i inventory.ini playbook.yaml --ask-pass
   ```

3. **Authentication Details**:
   - When prompted for the SSH password, enter the root password: `root`.
   - When prompted for the Apache user password, you can choose your own password for the `passwordUser`.

   Example:
   ```bash
   Enter the database password: [choose your password]
   ```

## Playbook Details

- **Hosts**: Targets servers in the `webservers` group.
- **Remote User**: Runs tasks as the `root` user.
- **Variables**: Prompts for the `db_password` at runtime for use in authentication setup.

### Tasks
1. **Install Apache Package**: Ensures the `apache2` package is installed and the package cache is updated.
2. **Install Apache Utils**: Installs `apache2-utils` for managing user authentication.
3. **Template Deployment**: Writes the server's hostname into the `/var/www/html/index.html` file using a Jinja2 template (`templates/name.j2`).
4. **Password File Creation**: Creates an `.htpasswd` file for the `passwordUser` with the provided password on the `ansible-webserver-2-1` host.
5. **Authentication Configuration**: Copies the authentication configuration file (`default.conf`) to enable password protection on `ansible-webserver-2-1`.
6. **Restart Apache**: Restarts the `apache2` service to apply configuration changes.

