# 🚀 Sprint10 — Terraform + Ansible (Yandex Cloud)

## 📌 Описание проекта

Проект предназначен для автоматизированного развертывания инфраструктуры в Yandex Cloud с последующей настройкой серверов.

Используемые инструменты:

* **Terraform** — создание инфраструктуры (VM, сеть и т.д.)
* **Ansible** — конфигурация серверов (например, установка и настройка Nginx)

---

## 📂 Структура проекта

### 🔧 Скрипты установки

* 📄 `install_terraform.sh`
  Устанавливает чистый Terraform

* 📄 `install_yc_terraform.sh`
  Устанавливает Terraform с профилем Yandex Cloud

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
  Inventory в формате INI

* 📄 `inventory.yaml`
  Inventory в формате YAML

* 📄 `inventory.tftpl`
  Шаблон inventory (используется Terraform)

* 🧩 `nginx.conf.j2`
  Jinja2-шаблон конфигурации Nginx

---

## 🔄 Как работает проект

```text
Terraform → создает инфраструктуру в Yandex Cloud
          → генерирует inventory

Ansible → подключается к серверам
         → применяет конфигурацию
         → настраивает Nginx
```

---

## ⚡ Порядок развертывания

### 1. Подготовка системы

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
chmod +x install_terraform.sh
chmod +x install_yc_terraform.sh
```

---

### 4. Установка Terraform

```bash
./install_terraform.sh
```

или (для Yandex Cloud):

```bash
./install_yc_terraform.sh
```

---

### 5. Развертывание инфраструктуры

```bash
cd terraform_yandex

terraform init
terraform validate
terraform apply
```

---

### 6. Настройка серверов через Ansible

```bash
cd ../ansible

ansible-playbook -i inventory.ini playbook.yml
```

---

## 🧠 Важно

* ❗ `terraform.tfstate` — не редактировать вручную
* 🔐 `terraform.tfvars` — может содержать секретные данные
* 📁 `.terraform/` — должен быть в `.gitignore`

---

## 📬 Автор

GitHub: https://github.com/WOLFbl4
