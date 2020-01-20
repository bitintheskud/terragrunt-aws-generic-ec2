#cloud-config
repo_update: true
repo_upgrade: all
package_upgrade: true

packages:
    - software-properties-common

ssh_authorized_keys:
    - ${authorized_key}
