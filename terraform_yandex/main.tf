# 1. Сетевая инфраструктура
resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-d" # Должно совпадать с зоной в providers.tf
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

# 2. Создание загрузочных дисков
resource "yandex_compute_disk" "boot-disk" {
  for_each = var.virtual_machines
  name     = each.value["disk_name"]
  type     = "network-hdd"
  zone     = "ru-central1-d"
  size     = each.value["disk"]
  image_id = each.value["template"]
}

# 3. Ресурс для создания, изменения и удаления ВМ
resource "yandex_compute_instance" "virtual_machine" {
  for_each = var.virtual_machines
  name     = each.value["vm_name"]
  zone     = "ru-central1-d"

  # Платформа (Intel Ice Lake для зоны D)
  platform_id = "standard-v3" 

  resources {
    cores  = each.value["vm_cpu"]
    memory = each.value["ram"]
    core_fraction = 20 # Опционально: экономит деньги, ограничивая производительность CPU
  }

  # ДЛЯ ПРЕРЫВАЕМОЙ МАШИНЫ ---
  scheduling_policy {
    preemptible = true # Делает машину прерываемой
  }

  # Разрешает Terraform останавливать ВМ для внесения изменений (обязательно)
  allow_stopping_for_update = true 

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk[each.key].id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    # nat       = true # Включает публичный IP для всех
    nat       = each.value["nat"] # Берет значение из tfvars для каждой ВМ
  }

  metadata = {
    # Позволяет заходить по SSH:
    ssh-keys = "${each.value["user_name"]}:${file("~/.ssh/id_ed25519.pub")}"
  }
}

# 4. Cоздавать файл инвентаря при каждом запуске для ansible
resource "local_file" "ansible_inventory" {
  # Указываем путь к папке ansible.
  filename = "${path.module}/../ansible/inventory.yaml"
  content = templatefile("${path.module}/inventory.tftpl", {
    vms = yandex_compute_instance.virtual_machine
  # Находим IP машины, которая будет бастионом
  bastion_ip = yandex_compute_instance.virtual_machine["vm-1"].network_interface.0.nat_ip_address
  })
}
# Удаление ВМ: Чтобы удалить конкретную машину, просто удалите её блок из файла terraform.tfvars. 
# Terraform увидит, что ресурс больше не описан в коде, и уничтожит его при следующем apply.
# Выполните terraform init (скачает провайдера).
# Выполните terraform plan (покажет, что будет создано).
# Выполните terraform apply (создаст ресурсы в облаке)

