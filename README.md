# Install Menu 

```bash
git clone https://github.com/Trihedraf/linux.confs && cd linux.confs && ./install.sh
```

# Arch System Setup Script

```bash
bash -c "$(curl -fsSL xurl.ing/arch)" -s --gui
```

# Debian Trixie System Setup Script

```bash
sudo apt install curl && bash -c "$(curl -fsSL xurl.ing/debian)" -s --zfs=OFF
```

# Proxmox System Setup Script

For using proxmox as a debian server with zfs-on-root built-in.

```bash
sed -i \
  -e 's|https://enterprise.proxmox.com/debian/ceph-squid|http://download.proxmox.com/debian/ceph-squid|g' \
  -e 's/Components: enterprise/Components: no-subscription/g' \
  /etc/apt/sources.list.d/ceph.sources

sed -i \
  -e 's|https://enterprise.proxmox.com/debian/pve|http://download.proxmox.com/debian/pve|g' \
  -e 's/Components: pve-enterprise/Components: pve-no-subscription/g' \
  /etc/apt/sources.list.d/pve-enterprise.sources && \
  mv /etc/apt/sources.list.d/pve-enterprise.sources /etc/apt/sources.list.d/pve.sources

newUser=YourUsername
apt install sudo
useradd -m -s /bin/bash $newUser
usermod -aG sudo $newUser
passwd $newUser
```

Login to new user.

```bash
bash -c "$(curl -fsSL xurl.ing/proxmox)"
```

Fix some Docker containers not having enough permissions

`sudo systemctl edit docker`

```sh
[Service]
Environment=container="setmeandforgetme"
newUser=YourUsername
```

`sudo systemctl daemon-reload`
`sudo systemctl restart docker`

## Nvidia Driver on Proxmox

```bash
wget https://developer.download.nvidia.com/compute/cuda/repos/debian13/x86_64/cuda-keyring_1.1-1_all.deb
sudo dpkg -i cuda-keyring_1.1-1_all.deb && sudo apt-get update && sudo apt-get install -y nvidia-open
sudo reboot
```

```bash
sudo apt-get update && sudo apt-get install -y --no-install-recommends \
   ca-certificates \
   gnupg2
```

```bash
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
```

```bash
sudo apt-get update && sudo apt-get install -y \
    nvidia-container-toolkit \
    nvidia-container-toolkit-base \
    libnvidia-container-tools \
    libnvidia-container1 \
    pve-headers
```

```bash
sudo nvidia-ctk runtime configure --runtime=docker && sudo systemctl restart docker
```
