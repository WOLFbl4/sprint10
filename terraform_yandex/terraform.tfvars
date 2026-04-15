virtual_machines = {
  "vm-1" = {
    vm_name   = "srv-01"
    vm_desc   = "web-server Nginx"
    vm_cpu    = 2
    ram       = 2
    disk      = 20
    disk_name = "disk-srv-01" # Уникальное имя
    template  = "fd83esfomhq25p2ono90"
    user_name = "ubuntu" # стандартное имя для официальных образов Ubuntu в облаках.
    nat       = true  # Будет публичный IP
  },
  "vm-2" = {
    vm_name   = "srv-02"
    vm_desc   = "server SQL1"
    vm_cpu    = 2
    ram       = 2
    disk      = 20
    disk_name = "disk-srv-02" # Уникальное имя
    template  = "fd83esfomhq25p2ono90"
    user_name = "ubuntu" # стандартное имя для официальных образов Ubuntu в облаках.
    nat       = false # Только внутренний IP
  },
  "vm-3" = {
    vm_name   = "srv-03"
    vm_desc   = "server SQL2"
    vm_cpu    = 2
    ram       = 2
    disk      = 20
    disk_name = "disk-srv-03" # Уникальное имя
    template  = "fd83esfomhq25p2ono90"
    user_name = "ubuntu" # стандартное имя для официальных образов Ubuntu в облаках.
    nat       = false # Только внутренний IP
  }
}
