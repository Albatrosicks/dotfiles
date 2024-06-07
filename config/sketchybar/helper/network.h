#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <stdbool.h>

#define MAX_INTERFACES 10

struct network {
  unsigned long prev_bytes_in[MAX_INTERFACES];
  unsigned long prev_bytes_out[MAX_INTERFACES];
  bool has_prev_data;

  char command[256];
};

static inline void network_init(struct network* net) {
  memset(net->prev_bytes_in, 0, sizeof(net->prev_bytes_in));
  memset(net->prev_bytes_out, 0, sizeof(net->prev_bytes_out));
  net->has_prev_data = false;
  snprintf(net->command, 100, "");
}

static inline void network_update(struct network* net) {
  FILE* file;
  char line[256];
  unsigned long bytes_in = 0, bytes_out = 0;

  file = popen("/usr/sbin/netstat -ib", "r");
  if (!file) {
    printf("Error: netstat command errored out...\n");
    return;
  }

  // Skip headers
  fgets(line, sizeof(line), file); // Skip the first header line

  // Read network data
  while (fgets(line, sizeof(line), file)) {
    char iface[16];
    unsigned long ibytes, obytes;
    sscanf(line, "%15s %*s %*s %*s %*s %*s %lu %*s %lu", iface, &ibytes, &obytes);

    // Sum up all interfaces data
    bytes_in += ibytes;
    bytes_out += obytes;
  }

  pclose(file);

  if (net->has_prev_data) {
    unsigned long delta_in = bytes_in - net->prev_bytes_in[0];
    unsigned long delta_out = bytes_out - net->prev_bytes_out[0];

    double download_speed = (double)delta_in / 1048576.0; // Convert to MB
    double upload_speed = (double)delta_out / 1048576.0; // Convert to MB

    char color[16];
    snprintf(color, 16, "%s", getenv("LABEL_COLOR"));

    snprintf(net->command, 256, "--push network.down %.2f "
                                "--push network.up %.2f "
                                "--set network.down label='Download: %.2f MB/s' label.color=%s "
                                "--set network.up label='Upload: %.2f MB/s' label.color=%s ",
                                download_speed,
                                upload_speed,
                                download_speed,
                                color,
                                upload_speed,
                                color);
  } else {
    snprintf(net->command, 256, "");
  }

  net->prev_bytes_in[0] = bytes_in;
  net->prev_bytes_out[0] = bytes_out;
  net->has_prev_data = true;
}
