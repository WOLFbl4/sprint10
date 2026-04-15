virtual_machines = {
  vm-1 = {
    vm_name   = "srv-01"
    vm_desc   = "Nginx proxy"
    vm_cpu    = 2
    ram       = 2
    disk      = 20
    disk_name = "disk-srv-01" # Уникальное имя
    template  = "fd83esfomhq25p2ono90"
    user_name = "ubuntu"  # стандартное имя для официальных образов Ubuntu в облаках.
    nat       = true      # Будет публичный IP
    role      = "proxy"   # Роль работает с inventory
  },

  vm-2 = {
    vm_name   = "srv-02"
    vm_desc   = "Nginx backend 1"
    vm_cpu    = 2
    ram       = 2
    disk      = 20
    disk_name = "disk-srv-02" # Уникальное имя
    template  = "fd83esfomhq25p2ono90"
    user_name = "ubuntu"  # стандартное имя для официальных образов Ubuntu в облаках.
    nat       = true      # Будет публичный IP. (false) - Только внутренний IP
    role      = "backend" # Роль работает с inventory
  },

  vm-3 = {
    vm_name   = "srv-03"
    vm_desc   = "Nginx backend 2"
    vm_cpu    = 2
    ram       = 2
    disk      = 20
    disk_name = "disk-srv-03" # Уникальное имя
    template  = "fd83esfomhq25p2ono90"
    user_name = "ubuntu"  # стандартное имя для официальных образов Ubuntu в облаках.
    nat       = true      # Будет публичный IP. (false) - Только внутренний IP
    role      = "backend" # Роль работает с inventory
  }
}
