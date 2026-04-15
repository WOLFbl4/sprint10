# 🚀 Sprint10 — Terraform + Ansible (Yandex Cloud)

## 📌 Описание проекта

Проект предназначен для автоматизированного развертывания инфраструктуры в Yandex Cloud с последующей настройкой серверов.

Используемые инструменты:

* **Terraform** — создание инфраструктуры (VM, сеть и т.д.)
* **Ansible** — конфигурация серверов (например, установка и настройка Nginx)

---

## 📂 Структура проекта

### 🔧 Скрипты установки

* 📄 `install_yc_terraform.sh`
  Устанавливает Terraform с профилем Yandex Cloud

* 📄 `install_ansible.sh`
  Устанавливает Ansible

---

## ☁️ Папка `terraform_yandex`

### Основные файлы

* 📄 `main.tf`
  Основная конфигурация инфраструктуры (ресурсы)

* 📄 `providers.tf`
  Настройка провайдера Yandex Cloud (регион, авторизация)

* 📄 `variables.tf`
  Описание переменных

* 📄 `terraform.tfvars`
  Значения переменных

* 📄 `output.tf`
  Выходные данные (например, IP-адреса)

---

### Служебные файлы

* 📁 `.terraform/`
  Кэш, провайдеры и модули *(не коммитится)*

* 🔒 `.terraform.lock.hcl`
  Фиксация версий провайдеров *(коммитится)*

* 📄 `terraform.tfstate`
  Текущее состояние инфраструктуры *(критически важный файл)*

* 📄 `terraform.tfstate.backup`
  Резервная копия состояния

---

### 🔗 Интеграция с Ansible

* 📄 `inventory.tftpl`
  Шаблон inventory для генерации списка хостов

---

## ⚙️ Папка `ansible`

* ⚙️ `ansible.cfg`
  Основной конфигурационный файл Ansible

* 📄 `inventory.ini`
  Inventory в формате INI (список серверов)

* 📄 `inventory.yaml`
  Inventory в формате YAML (список серверов)

* 📄 `inventory.tftpl`
  Шаблон inventory (используется Terraform)

* 📄 `playbook.yml`
  Главный сценарий Ansible. Определяет что запускать и на каких серверах

* 📁 `roles/`
  Здесь хранится вся логика. Каждая роль - отдельная задача

* 🧩 `roles/common`
  Базовая настройка всех серверов
  
* 📄 `roles/common/tasks/main.yml`
  Устанавливает базовые пакеты

* 🧩 `roles/nginx_backend`
  Отдающий сервер (backend)
  
* 📄 `roles/nginx_backend/tasks/main.yml`
  Устанавливает nginx. Копирует HTML страницу index.html.j2. Запускает сервис
  
* 📄 `roles/nginx_backend/templates/index.html.j2`
  Шаблон страницы

* 🧩 `roles/nginx_proxy`
  Проксирующий сервер (балансировщик)
  
* 📄 `roles/nginx_proxy/tasks/main.yml`
  Устанавливает nginx. Пприменяет конфиг. Запускает nginx
  
* 📄 `roles/nginx_proxy/templates/nginx.conf.j2`
  Конфиг Nginx

---

## 🔄 Как работает проект

```text
1. Terraform
   → создает ВМ
   → генерирует inventory

2. Ansible:
   → common (все ВМ)
   → nginx_backend (backend)
   → nginx_proxy (proxy)

4. Результат:
   :3000 → proxy → backend → "Hello from <hostname>"
```

---

## ⚡ Порядок развертывания

### 1. Подготовка системы

### 🔐 Создание SSH-ключа

Для подключения к виртуальным машинам необходимо создать SSH-ключ.

#### Генерация ключа

Выполните команду на Linux:

```bash
ssh-keygen -t ed25519
```

---

#### Что произойдет

* Будет создано **два файла**:

  * `~/.ssh/id_ed25519` — приватный ключ (хранить в секрете)
  * `~/.ssh/id_ed25519.pub` — публичный ключ

---

#### Использование ключа

* Публичный ключ (`.pub`) используется при создании ВМ (через Terraform)
* Приватный ключ используется для подключения:

```bash
ssh ubuntu@<IP_адрес>
```

---

### ⚠️ Важно

* ❗ Никогда не передавайте приватный ключ (`id_ed25519`)
* 📁 Убедитесь, что права доступа корректны:

```bash
chmod 600 ~/.ssh/id_ed25519
```

###  Установка git

```bash
sudo apt update
sudo apt install -y git
```

---

### 2. Клонирование репозитория

```bash
cd ~
git clone https://github.com/WOLFbl4/sprint10.git
cd sprint10
```

---

### 3. Выдача прав на скрипты

```bash
chmod +x install_yc_terraform.sh
chmod +x install_ansible.sh
```

---

### 4. Установка Terraform для Yandex Cloud:

```bash
./install_yc_terraform.sh
```

### 5. Установка Аnsible:

```bash
./install_ansible.sh
```

### 6. Настройка профиля Yandex Cloud

Перед использованием Terraform необходимо настроить профиль Yandex Cloud.

#### 🔹Получение идентификаторов

1. Перейдите в консоль Yandex Cloud
2. Нажмите на имя облака (начинается с `cloud-`)
   → скопируйте **Cloud ID**
3. Выберите каталог (folder) внутри облака
   → скопируйте **Folder ID**
4. Создать (открыть) сервисный аккаунт.
   → Cкопируйте **ID аккаунта**

Дальше создайте ключ авторизации в облаке для провайдера:

```bash
yc iam key create \
  --service-account-id <ID аккаунта> \
  --folder-name default \
  --output key.json
```

---

#### 🔹 Настройка профиля

Создайте профиль:

```bash
yc config profile create <имя_профиля>
```

Укажите сервисный ключ:

```bash
yc config set service-account-key key.json
```

Установите идентификаторы:

```bash
yc config set cloud-id <CLOUD_ID>
yc config set folder-id <FOLDER_ID>
```

---

#### 🔹 Экспорт переменных окружения

```bash
export YC_TOKEN=$(yc iam create-token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)
```

---

### ⚠️ Важно

* 📄 `key.json` — ключ сервисного аккаунта (не добавлять в репозиторий)
---


---

### 7. Развертывание инфраструктуры

```bash
cd ~/sprint10/terraform_yandex

terraform init
terraform validate
terraform apply
```

---

### 8. Настройка серверов через Ansible

```bash
cd ../ansible

ansible-playbook -i inventory.yaml playbook.yml
```

---

### 9. Дополнительные команды

#### Выключить конкретную машину

```bash
yc compute instance stop srv-01
```

#### Выключить все машины (если их много)

```bash
yc compute instance list | awk 'NR>3 {print $2}' | xargs -L1 yc compute instance stop
```
---

## 🧠 Важно

* ❗ `terraform.tfstate` — не редактировать вручную
* 🔐 `terraform.tfvars` — может содержать секретные данные

---

## 📬 Автор

GitHub: https://github.com/WOLFbl4
