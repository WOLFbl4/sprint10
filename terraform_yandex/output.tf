output "vm_info" {
  description = "Общая информация о созданных ВМ"
  value = {
    for k, v in yandex_compute_instance.virtual_machine : k => {
      name       = v.name
      private_ip = v.network_interface.0.ip_address
      public_ip  = v.network_interface.0.nat_ip_address
    }
  }
}
