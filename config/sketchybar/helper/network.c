#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/sysctl.h>
#include <ifaddrs.h>
#include <net/if.h>
#include <stdbool.h>
#include <time.h>

struct network {
  uint64_t prev_in_bytes;
  uint64_t prev_out_bytes;
  bool has_prev_data;
  char command[256];
};

static inline void network_init(struct network* net) {
  net->prev_in_bytes = 0;
  net->prev_out_bytes = 0;
  net->has_prev_data = false;
  snprintf(net->command, 256, "");
}

static inline void network_update(struct network* net) {
  struct ifaddrs *ifaddr, *ifa;
  uint64_t total_in_bytes = 0;
  uint64_t total_out_bytes = 0;

  if (getifaddrs(&ifaddr) == -1) {
    printf("Error: Could not get network interfaces.\n");
    return;
  }

  for (ifa = ifaddr; ifa != NULL; ifa = ifa->ifa_next) {
    if (ifa->ifa_addr == NULL) continue;

    if (ifa->ifa_addr->sa_family == AF_LINK) {
      struct if_data *if_data = (struct if_data *)ifa->ifa_data;
      total_in_bytes += if_data->ifi_ibytes;
      total_out_bytes += if_data->ifi_obytes;
    }
  }

  freeifaddrs(ifaddr);

  if (net->has_prev_data) {
    uint64_t delta_in = total_in_bytes - net->prev_in_bytes;
    uint64_t delta_out = total_out_bytes - net->prev_out_bytes;

    double in_speed = delta_in / 1024.0 / 4.0; // KB/s
    double out_speed = delta_out / 1024.0 / 4.0; // KB/s

    char color[16];
    if (in_speed >= 1000 || out_speed >= 1000) {
      snprintf(color, 16, "%s", getenv("RED"));
    } else if (in_speed >= 300 || out_speed >= 300) {
      snprintf(color, 16, "%s", getenv("ORANGE"));
    } else if (in_speed >= 100 || out_speed >= 100) {
      snprintf(color, 16, "%s", getenv("YELLOW"));
    } else {
      snprintf(color, 16, "%s", getenv("LABEL_COLOR"));
    }

    snprintf(net->command, 256, "--push net.in %.2f "
                                "--push net.out %.2f "
                                "--set net.in label='%.2f KB/s' "
                                "--set net.out label='%.2f KB/s' "
                                "--set net.percent label='%.2f/%.2f KB/s' label.color=%s ",
                                in_speed,
                                out_speed,
                                in_speed,
                                out_speed,
                                in_speed,
                                out_speed,
                                color          );
  } else {
    snprintf(net->command, 256, "");
  }

  net->prev_in_bytes = total_in_bytes;
  net->prev_out_bytes = total_out_bytes;
  net->has_prev_data = true;
}
