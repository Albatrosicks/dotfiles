#include <mach/mach.h>
#include <mach/mach_host.h>
#include <stdbool.h>
#include <unistd.h>
#include <stdio.h>

struct ram {
  mach_port_t host;
  vm_size_t page_size;
  vm_statistics64_data_t vm_stats;

  int used_ram;
  int free_ram;
  int total_ram;
};

static inline void ram_init(struct ram* ram) {
  ram->host = mach_host_self();
  host_page_size(ram->host, &ram->page_size);
}

static inline void ram_update(struct ram* ram) {
  mach_msg_type_number_t count = sizeof(ram->vm_stats) / sizeof(integer_t);
  kern_return_t error = host_statistics64(ram->host, HOST_VM_INFO,
                                          (host_info64_t)&ram->vm_stats, &count);

  if (error != KERN_SUCCESS) {
    printf("Error: Could not read RAM statistics.\n");
    return;
  }

  ram->free_ram = (ram->vm_stats.free_count + ram->vm_stats.inactive_count) * ram->page_size / (1024 * 1024);
  ram->used_ram = (ram->vm_stats.active_count + ram->vm_stats.wire_count) * ram->page_size / (1024 * 1024);
  ram->total_ram = ram->free_ram + ram->used_ram;
}

