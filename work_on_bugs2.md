# Работа №2 над ошибками по занятию «Управляющие конструкции в коде Terraform»

## Ошибка 1
"Доброго дня. Вопрос был по машине “storage”, а не for-each.
Спасибо за исправления

PS Прошу так же обратить внимание на этот комментарий - одиночную(использовать count или for_each запрещено из-за задания №4)"
Тут я не понял что имеется ввиду, поэтому логика тут такая:

в файле ansible.tf есть такой код который относится к storage и говорит о том, что он отрабатывает от 1 и до 999 машин
```bash
%{if length(yandex_compute_instance.storagevm) > 0}
    [storage]
    ${yandex_compute_instance.storagevm.name} ansible_host=${yandex_compute_instance.storagevm.network_interface[0].nat_ip_address} fqdn=${yandex_compute_instance.storagevm.fqdn}
    %{endif}
```
Согласно 3.2 заданию:
Создайте в том же файле одиночную(использовать count или for_each запрещено из-за задания №4) ВМ c именем "storage" .
решение задания:
```bash
resource "yandex_compute_instance" "storagevm" {
    name = "storage"
    folder_id   = var.folder_id
    zone        = var.default_zone

    allow_stopping_for_update = var.platform.allow_stopping_for_update

    resources {
        cores         = var.vms_resources.cores
        memory        = var.vms_resources.memory
        core_fraction = var.vms_resources.core_fraction
    }

    boot_disk {
        initialize_params {
        image_id = data.yandex_compute_image.ubuntu.id
        size     = var.platform.size
        type     = var.platform.type
        }
    }
    
    dynamic secondary_disk {
        for_each = "${yandex_compute_disk.empty-disk.*.id}"
        content {
          disk_id = secondary_disk.value
        }
    }  

    network_interface {
        subnet_id           = yandex_vpc_subnet.develop.id
        nat                 = var.network_interface.nat
    }

    metadata = {
        serial-port-enable = var.metadata.serial-port-enable
        ssh-keys           = "storage:${local.ssh_key}"
    }
}
```

for_each используется только для подлкючения дополнительных дисков согласно заданию 3.2 "Используйте блок dynamic secondary_disk{..} и мета-аргумент for_each для подключения созданных вами дополнительных дисков."