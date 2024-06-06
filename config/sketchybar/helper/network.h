#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <stdbool.h>

#define MAX_INTERFACES 10
#define MBIT_TO_BYTES 1250000 // 10 Mbit/s = 1250000 bytes/s

struct network {
  unsigned long prev_bytes_in[MAX_INTERFACES];
  unsigned long prev_bytes_out[MAX_INTERFACES];
  bool has_prev_data;

  unsigned long max_speed_in;
  unsigned long max_speed_out;

  char command[256];
};

static inline void network_init(struct network* net) {
  memset(net->prev_bytes_in, 0, sizeof(net->prev_bytes_in));
  memset(net->prev_bytes_out, 0, sizeof(net->prev_bytes_out));
  net->has_prev_data = false;
  net->max_speed_in = MBIT_TO_BYTES;
  net->max_speed_out = MBIT_TO_BYTES;
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

    double download_speed = (double)delta_in; // Speed in bytes/s
    double upload_speed = (double)delta_out; // Speed in bytes/s

    // Update max speed if current speed is higher
    if (download_speed > net->max_speed_in) net->max_speed_in = download_speed;
    if (upload_speed > net->max_speed_out) net->max_speed_out = upload_speed;

    // Calculate percentage
    double download_perc = (download_speed / (net->max_speed_in > MBIT_TO_BYTES ? net->max_speed_in : MBIT_TO_BYTES)) * 100;
    double upload_perc = (upload_speed / (net->max_speed_out > MBIT_TO_BYTES ? net->max_speed_out : MBIT_TO_BYTES)) * 100;

    snprintf(net->command, 256, "--push network.down %.2f "
                                "--push network.up %.2f "
                                "--set network.down label='Download: %.2f MB/s' "
                                "--set network.up label='Upload: %.2f MB/s' ",
                                download_perc,
                                upload_perc,
                                download_speed / 1048576.0,
                                upload_speed / 1048576.0);
  } else {
    snprintf(net->command, 256, "");
  }

  net->prev_bytes_in[0] = bytes_in;
  net->prev_bytes_out[0] = bytes_out;
  net->has_prev_data = true;
}
