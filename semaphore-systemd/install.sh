#!/bin/bash

DEFCONFIG="/etc/default/ansible-semaphore"
ETCFILE="/etc/ansible-semaphore/semaphore_config.json"


if [ "$(hostname)" != "semaphore0" ]
then
  echo "Run on semaphore0 as root."
  exit 1
fi


if [ ! -f "${ETCFILE}" ]
then
 echo "No config file deployed, fix it please."
fi

if [ ! -f "${DEFCONFIG}" ]
then
 echo '#Ansible Semaphore Defaults'                 > "${DEFCONFIG}"
 echo "SEMAPHORE_CONFIG=${ETCFILE}"                >> "${DEFCONFIG}"
fi

cat > /etc/systemd/system/semaphore.service <<'EOF'
[Unit]
Description=Ansible Semaphore


[Service]
Type=forking
EnvironmentFile=-/etc/default/ansible-semaphore
ExecStart=/bin/sh -c "/usr/bin/semaphore server --config ${SEMAPHORE_CONFIG}&"
Restart=always
RestartSec=10s

[Install]
WantedBy=multi-user.target

EOF

systemctl daemon-reload
systemctl enable --now semaphore


