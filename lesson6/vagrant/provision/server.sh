#!/usr/bin/env bash
set -eux

# Готовим SSH для пользователя vagrant
install -d -m 700 /home/vagrant/.ssh
touch /home/vagrant/.ssh/authorized_keys
chmod 600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh

# Забираем публичный ключ клиента из shared folder и добавляем в authorized_keys
if [ -f /vagrant/provision/client_id_ed25519.pub ]; then
  cat /vagrant/provision/client_id_ed25519.pub >> /home/vagrant/.ssh/authorized_keys
  sort -u /home/vagrant/.ssh/authorized_keys -o /home/vagrant/.ssh/authorized_keys
  chown vagrant:vagrant /home/vagrant/.ssh/authorized_keys
fi

systemctl restart ssh
