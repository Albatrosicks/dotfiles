#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include "cpu.h"
#include "network.h"
#include "sketchybar.h"

struct cpu g_cpu;
struct network g_network;

void handler(env env) {
  // Environment variables passed from sketchybar can be accessed as seen below
  char* name = env_get_value_for_key(env, "NAME");

  if (strcmp(name, "cpu.percent") == 0) {
    // CPU graph updates
    cpu_update(&g_cpu);
    if (strlen(g_cpu.command) > 0) sketchybar(g_cpu.command);
  } else if (strcmp(name, "network.down") == 0 || strcmp(name, "network.up") == 0) {
    // Network graph updates
    network_update(&g_network);
    if (strlen(g_network.command) > 0) sketchybar(g_network.command);
  }
}

int main(int argc, char** argv) {
  cpu_init(&g_cpu);
  network_init(&g_network);

  if (argc < 2) {
    printf("Usage: helper \"<bootstrap name>\"\n");
    exit(1);
  }

  event_server_begin(handler, argv[1]);
  return 0;
}
