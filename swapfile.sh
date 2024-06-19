# Install swap
sudo apt-get install htop -y
fallocate -l 4G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
cp /etc/fstab /etc/fstab.bak
echo '/swapfile none swap sw 0 0' | tee -a /etc/fstab
sysctl vm.swappiness=10
sysctl vm.vfs_cache_pressure=50
cp /etc/sysctl.conf /etc/sysctl.conf.bak
echo "vm.swappiness=10" | tee -a /etc/sysctl.conf >/dev/null
echo "vm.vfs_cache_pressure=50" |tee -a /etc/sysctl.conf >/dev/null
