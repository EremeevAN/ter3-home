# Домашнее задание к занятию «Управляющие конструкции в коде Terraform»
## Задача 1
Иницилизируем проект и проверяем группу безопасности в Yandex Cloud
![image](https://github.com/EremeevAN/ter3-home/blob/main/images/2_1.png)

## Задача 2
Создаем файл count-vm.tf. В котором описаны две одинаковые ВМ web-1 и web-2 с минимальными параметрами, используя мета-аргумент count loop.

![image](https://github.com/EremeevAN/ter3-home/blob/main/images/9.png)

Применяем изменения и получаем результат:

![image](https://github.com/EremeevAN/ter3-home/blob/main/images/3.png)



 Назначаем ВМ группу безопасности. В файле count-vm.tf пропишем в блок network_interface строчку
 ...
 security_group_ids  = [yandex_vpc_security_group.example.id]
 ...



Создаем файл for_each-vm.tf. ДЛя двух ВМ с базами данных назначим имена "main" и "replica", и с разными по cpu/ram/disk_volume , используя мета-аргумент for_each loop.

Выполняем и получаем результат

![image](https://github.com/EremeevAN/ter3-home/blob/main/images/4.png)


## Задача 3
Создаём 3 одинаковых виртуальных диска размером 1 Гб
```bash
resource "yandex_compute_disk" "empty-disk" {
  count = 3
  
  name       = format("disk-%02d", count.index + 1)
  type       = var.diskmgmt.type
  zone       = var.default_zone
  size       = var.diskmgmt.size
  block_size = var.diskmgmt.block_size
```
Результат:
![image](https://github.com/EremeevAN/ter3-home/blob/main/images/5.png)

Подключаем к ВМ Storage диски(Прописываем в файле disk_vm.tf, в resource "yandex_compute_instance" "storagevm")
```bash
    dynamic secondary_disk {
        for_each = "${yandex_compute_disk.empty-disk.*.id}"
        content {
          disk_id = secondary_disk.value
        }
    }  
```

Результат:

![image](https://github.com/EremeevAN/ter3-home/blob/main/images/7.png)
## Задача 4
Создаем файл ansible.tf
![image](https://github.com/EremeevAN/ter3-home/blob/main/images/10.png)

Принменяем и получаем результат
![image](https://github.com/EremeevAN/ter3-home/blob/main/images/8.png)
