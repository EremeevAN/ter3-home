variable "vms_resources" {
  type = map
    default = {
      cores         = 2
      memory        = 2  
      core_fraction = 20 
  }
}