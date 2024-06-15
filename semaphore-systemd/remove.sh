#!/bin/bash


systemctl disable --now semaphore

rm /etc/systemd/system/semaphore.service

systemctl daemon-reload

