#!/bin/bash

set -e

echo "Удаление старого Ansible (apt)"
sudo apt remove ansible -y || true

echo "Удаление Ansible из pip (если был)"
pip uninstall ansible ansible-core -y || true
pip3 uninstall ansible ansible-core -y || true

echo "Установка зависимостей"
sudo apt update
sudo apt install -y python3-pip python3-venv

echo "Обновление pip"
python3 -m pip install --upgrade pip

echo "Создание виртуального окружения"
python3 -m venv ~/ansible-venv

echo "Активация окружения"
source ~/ansible-venv/bin/activate

echo "Установка Ansible..."
pip install ansible

echo "Добавление venv в PATH"
echo 'source ~/ansible-venv/bin/activate' >> ~/.bashrc
echo 'export PATH=$HOME/ansible-venv/bin:$PATH' >> ~/.bashrc
source ~/.bashrc

echo "Проверка версии Ansible:"
ansible --version

echo "Установка завершена!"
