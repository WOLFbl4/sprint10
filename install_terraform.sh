#!/bin/bash

# 1. Обновляем систему и устанавливаем необходимые программы
sudo apt update && sudo apt install -y gnupg software-properties-common wget curl unzip


# 2. Скачиваем и устанавливаем GPG-ключ HashiCorp
wget -O- https://hashicorp.com | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

# 3. Проверяем отпечаток ключа
gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint

# 4. Добавляем официальный репозиторий HashiCorp для Ubuntu 24.04
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

# 5. Обновляем информацию о репозиториях и устанавливаем Terraform
sudo apt update
sudo apt install -y terraform

# 6. Проверка установки
echo "Установка Terraform завершена!"
terraform -version

