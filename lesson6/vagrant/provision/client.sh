#!/usr/bin/env bash
set -eux

# Генерим ключ на client для пользователя vagrant
install -d -m 700 /home/vagrant/.ssh

if [ ! -f /home/vagrant/.ssh/id_ed25519 ]; then
  sudo -u vagrant ssh-keygen -t ed25519 -N "" -f /home/vagrant/.ssh/id_ed25519
fi

chmod 600 /home/vagrant/.ssh/id_ed25519
chmod 644 /home/vagrant/.ssh/id_ed25519.pub
chown -R vagrant:vagrant /home/vagrant/.ssh

# Положим pubkey в общую папку /vagrant (чтобы server мог забрать)
cp /home/vagrant/.ssh/id_ed25519.pub /vagrant/provision/client_id_ed25519.pub

# Создадим шпаргалку
cat > /home/vagrant/SSH_TO_SERVER.txt <<EOF
Run:
  ssh -i /home/vagrant/.ssh/id_ed25519 vagrant@server
or:
  ssh -i /home/vagrant/.ssh/id_ed25519 vagrant@192.168.56.10
EOF
chown vagrant:vagrant /home/vagrant/SSH_TO_SERVER.txt
