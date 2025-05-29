# Работа над ошибками по занятию «Управляющие конструкции в коде Terraform»

## Ошибка 1
в файле disk_vm.tf и for_each-vm.tf ошибка в строке image_id = "fd81hgrcv6lsnkremf32" 
```bash
boot_disk {
        initialize_params {
        image_id = "fd81hgrcv6lsnkremf32"
        size     = var.platform.size
        type     = var.platform.type
        }
    }
```

Прописываем image_id = data.yandex_compute_image.ubuntu.id
стало:
```bash
    boot_disk {
        initialize_params {
        image_id = data.yandex_compute_image.ubuntu.id
        size     = var.platform.size
        type     = var.platform.type
        }
    }
```

Добавляем в main.tf:
```bash
data "yandex_compute_image" "ubuntu" {
  family = var.platform.family
}
```

Ошибка исправлена.


## Ошибка 2
"Ваш код не может выполнить это задание - Инвентарь должен содержать 3 группы и быть динамическим, т. е. обработать как группу из 2-х ВМ, так и 999 ВМ."
Для избежания путанницы в файле for_each-vm.tf исправим на:

```bash
resource "yandex_compute_instance" "hw3each" {
    for_each = { for vm in var.each_vm : vm.vm_name => vm }
```

Была ошибка в файле ansible.tf. Правильный вариант:
```bash
 %{if length(yandex_compute_instance.hw3each) > 0}
    [databases]
    %{for s in yandex_compute_instance.hw3each}
```

Для тестирования в count-vm.tf прописал 5 ВМ. Применил изменения и получил результат:
В консоли:
    
![image](https://github.com/EremeevAN/ter3-home/blob/main/images/12.png)
    
В выходном файле:

![image](https://github.com/EremeevAN/ter3-home/blob/main/images/13.png)

P.S. Изменения в основной отчет (https://github.com/EremeevAN/ter3-home/blob/main/homeworks_ter-03.md) выполнил 
