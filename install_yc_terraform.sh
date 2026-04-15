#!/bin/bash

# Останавливать выполнение при любой ошибке
set -e

echo "Начинаю установку инструментов для Yandex Cloud..."

# 1. Обновление системы и установка зависимостей
echo " Шаг 1: Установка wget, curl, unzip..."
sudo apt update && sudo apt install -y wget curl unzip

# 2. Установка Terraform из зеркала Yandex
echo "Шаг 2: Установка Terraform v_1.9.2 с зеркала Яндекса..."
wget https://hashicorp-releases.yandexcloud.net/terraform/1.9.2/terraform_1.9.2_linux_amd64.zip && sudo unzip terraform_1.9.2_linux_amd64.zip -d /usr/bin

# 3. Проверка установки Terraform
echo "Проверка версии Terraform:"
terraform --version

# 4. Установка Yandex Cloud CLI (yc)
echo "Шаг 3: Установка Yandex Cloud CLI..."
curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash -s -- -a

# Определение файла профиля (zsh или bash)
SHELL_RC="$HOME/.bashrc"
[[ "$SHELL" == *"zsh"* ]] && SHELL_RC="$HOME/.zshrc"

# Добавление пути в PATH, если его там еще нет
if ! grep -q "yandex-cloud/bin" "$SHELL_RC"; then
    echo 'export PATH=$PATH:$HOME/yandex-cloud/bin' >> "$SHELL_RC"
    echo "Путь добавлен в $SHELL_RC"
fi

# Экспорт пути для текущей сессии скрипта
export PATH=$PATH:$HOME/yandex-cloud/bin

# 5. Копирование бинарных файлов yc в системную директорию (опционально)
echo "Шаг 4: Копирование исполняемых файлов yc в /usr/local/bin..."
sudo cp "$HOME/yandex-cloud/bin/yc" /usr/local/bin/

# 6. Настроим зеркало для скачивания провайдера
echo "Создание ~/.terraformrc"
cat <<EOF > ~/.terraformrc
provider_installation {
  network_mirror {
    url = "https://terraform-mirror.yandexcloud.net/"
    include = ["registry.terraform.io/*/*"]
  }
  direct {
    exclude = ["registry.terraform.io/*/*"]
  }
}
EOF

echo "Файл ~/.terraformrc создан"
echo "Проверка содержимого:"
cat ~/.terraformrc
chmod +x -R ~/.terraformrc

# 7. Финальная инициализация
echo "---------------------------------------------------"
echo "Установка завершена!"
echo "Далее перейдите по ссылке, которая будет выведена в консоль для настройки доступа к облаку."
echo "---------------------------------------------------"

# Запуск инициализации 
yc init
