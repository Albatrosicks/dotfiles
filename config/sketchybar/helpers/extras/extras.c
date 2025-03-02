#include <Carbon/Carbon.h>
#include <ApplicationServices/ApplicationServices.h>
#include <libproc.h>
#include <string.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

#define MAX_PROCESS_NAME 256

void ax_init() {
  const void *keys[] = { kAXTrustedCheckOptionPrompt };
  const void *values[] = { kCFBooleanTrue };

  CFDictionaryRef options;
  options = CFDictionaryCreate(kCFAllocatorDefault,
                               keys,
                               values,
                               sizeof(keys) / sizeof(*keys),
                               &kCFCopyStringDictionaryKeyCallBacks,
                               &kCFTypeDictionaryValueCallBacks     );

  bool trusted = AXIsProcessTrustedWithOptions(options);
  CFRelease(options);
  if (!trusted) {
    printf("Please enable accessibility access for this application in System Preferences > Security & Privacy > Privacy > Accessibility\n");
    exit(1);
  }
}

// Получить PID процесса ControlCenter
pid_t get_control_center_pid() {
  int proc_count = proc_listpids(PROC_ALL_PIDS, 0, NULL, 0) / sizeof(pid_t);
  pid_t all_pids[proc_count];
  proc_listpids(PROC_ALL_PIDS, 0, all_pids, sizeof(all_pids));

  for (int i = 0; i < proc_count; i++) {
    if (all_pids[i] == 0) continue;

    char path[PROC_PIDPATHINFO_MAXSIZE];
    if (proc_pidpath(all_pids[i], path, sizeof(path)) > 0) {
      char *name = strrchr(path, '/');
      if (name && strcmp(name + 1, "ControlCenter") == 0) {
        return all_pids[i];
      }
    }
  }

  return 0;
}

// Функция для нормализации строки (удаление спецсимволов, приведение к нижнему регистру)
void normalize_string(const char *input, char *output, size_t output_size) {
  size_t i = 0, j = 0;

  while (input[i] != '\0' && j < output_size - 1) {
    // Пропускаем все не-алфавитные и не-цифровые символы
    if (isalnum((unsigned char)input[i])) {
      output[j++] = tolower((unsigned char)input[i]);
    }
    i++;
  }

  output[j] = '\0';
}

// Найти и кликнуть по элементу трея по его ID
bool click_menu_item_by_id(int id) {
  pid_t pid = get_control_center_pid();
  if (pid == 0) {
    printf("ControlCenter process not found\n");
    return false;
  }

  AXUIElementRef app = AXUIElementCreateApplication(pid);
  if (!app) {
    printf("Failed to create AXUIElement for ControlCenter\n");
    return false;
  }

  CFTypeRef extrasMenuBar = NULL;
  AXError error = AXUIElementCopyAttributeValue(app, kAXExtrasMenuBarAttribute, &extrasMenuBar);

  if (error != kAXErrorSuccess || !extrasMenuBar) {
    printf("Failed to get extras menu bar, error: %d\n", error);
    CFRelease(app);
    return false;
  }

  CFArrayRef children = NULL;
  error = AXUIElementCopyAttributeValue(extrasMenuBar, kAXChildrenAttribute, (CFTypeRef*)&children);

  if (error != kAXErrorSuccess || !children) {
    printf("Failed to get children, error: %d\n", error);
    CFRelease(extrasMenuBar);
    CFRelease(app);
    return false;
  }

  CFIndex count = CFArrayGetCount(children);

  if (id < 0 || id >= count) {
    printf("Invalid ID: %d. Valid range is 0-%ld\n", id, count - 1);
    CFRelease(children);
    CFRelease(extrasMenuBar);
    CFRelease(app);
    return false;
  }

  AXUIElementRef item = CFArrayGetValueAtIndex(children, id);

  // Получаем описание для вывода
  CFStringRef desc = NULL;
  error = AXUIElementCopyAttributeValue(item, kAXDescriptionAttribute, (CFTypeRef*)&desc);

  if (error == kAXErrorSuccess && desc) {
    char desc_buffer[256];
    CFStringGetCString(desc, desc_buffer, sizeof(desc_buffer), kCFStringEncodingUTF8);
    printf("Clicking menu item %d: %s\n", id, desc_buffer);
    CFRelease(desc);
  } else {
    printf("Clicking menu item %d\n", id);
  }

  // Выполняем клик
  error = AXUIElementPerformAction(item, kAXPressAction);

  bool success = (error == kAXErrorSuccess);
  if (!success) {
    printf("Failed to click menu item, error: %d\n", error);
  }

  CFRelease(children);
  CFRelease(extrasMenuBar);
  CFRelease(app);

  return success;
}

// Найти и кликнуть по элементу трея по его описанию
bool click_menu_item_by_description(const char *description) {
  pid_t pid = get_control_center_pid();
  if (pid == 0) {
    printf("ControlCenter process not found\n");
    return false;
  }

  AXUIElementRef app = AXUIElementCreateApplication(pid);
  if (!app) {
    printf("Failed to create AXUIElement for ControlCenter\n");
    return false;
  }

  CFTypeRef extrasMenuBar = NULL;
  AXError error = AXUIElementCopyAttributeValue(app, kAXExtrasMenuBarAttribute, &extrasMenuBar);

  if (error != kAXErrorSuccess || !extrasMenuBar) {
    printf("Failed to get extras menu bar, error: %d\n", error);
    CFRelease(app);
    return false;
  }

  CFArrayRef children = NULL;
  error = AXUIElementCopyAttributeValue(extrasMenuBar, kAXChildrenAttribute, (CFTypeRef*)&children);

  if (error != kAXErrorSuccess || !children) {
    printf("Failed to get children, error: %d\n", error);
    CFRelease(extrasMenuBar);
    CFRelease(app);
    return false;
  }

  CFIndex count = CFArrayGetCount(children);
  bool found = false;

  // Нормализуем искомую строку
  char normalized_search[256];
  normalize_string(description, normalized_search, sizeof(normalized_search));

  for (CFIndex i = 0; i < count; i++) {
    AXUIElementRef child = CFArrayGetValueAtIndex(children, i);

    CFStringRef desc = NULL;
    error = AXUIElementCopyAttributeValue(child, kAXDescriptionAttribute, (CFTypeRef*)&desc);

    if (error == kAXErrorSuccess && desc) {
      char desc_buffer[256];
      CFStringGetCString(desc, desc_buffer, sizeof(desc_buffer), kCFStringEncodingUTF8);

      // Нормализуем описание элемента
      char normalized_desc[256];
      normalize_string(desc_buffer, normalized_desc, sizeof(normalized_desc));

      // Проверяем, содержит ли нормализованное описание искомую строку
      if (strstr(normalized_desc, normalized_search) != NULL) {
        printf("Found menu item: %s\n", desc_buffer);

        // Выполняем клик
        error = AXUIElementPerformAction(child, kAXPressAction);
        if (error != kAXErrorSuccess) {
          printf("Failed to click menu item, error: %d\n", error);
        } else {
          printf("Successfully clicked menu item\n");
          found = true;
        }

        CFRelease(desc);
        break;
      }

      CFRelease(desc);
    }
  }

  CFRelease(children);
  CFRelease(extrasMenuBar);
  CFRelease(app);

  return found;
}

// Вывести список всех доступных элементов трея
void list_menu_items() {
  pid_t pid = get_control_center_pid();
  if (pid == 0) {
    printf("ControlCenter process not found\n");
    return;
  }

  AXUIElementRef app = AXUIElementCreateApplication(pid);
  if (!app) {
    printf("Failed to create AXUIElement for ControlCenter\n");
    return;
  }

  CFTypeRef extrasMenuBar = NULL;
  AXError error = AXUIElementCopyAttributeValue(app, kAXExtrasMenuBarAttribute, &extrasMenuBar);

  if (error != kAXErrorSuccess || !extrasMenuBar) {
    printf("Failed to get extras menu bar, error: %d\n", error);
    CFRelease(app);
    return;
  }

  CFArrayRef children = NULL;
  error = AXUIElementCopyAttributeValue(extrasMenuBar, kAXChildrenAttribute, (CFTypeRef*)&children);

  if (error != kAXErrorSuccess || !children) {
    printf("Failed to get children, error: %d\n", error);
    CFRelease(extrasMenuBar);
    CFRelease(app);
    return;
  }

  CFIndex count = CFArrayGetCount(children);
  printf("Found %ld menu items:\n", count);

  for (CFIndex i = 0; i < count; i++) {
    AXUIElementRef child = CFArrayGetValueAtIndex(children, i);

    CFStringRef desc = NULL;
    error = AXUIElementCopyAttributeValue(child, kAXDescriptionAttribute, (CFTypeRef*)&desc);

    if (error == kAXErrorSuccess && desc) {
      char desc_buffer[256];
      CFStringGetCString(desc, desc_buffer, sizeof(desc_buffer), kCFStringEncodingUTF8);
      printf("%ld: %s\n", i, desc_buffer);
      CFRelease(desc);
    } else {
      printf("%ld: (no description)\n", i);
    }
  }

  CFRelease(children);
  CFRelease(extrasMenuBar);
  CFRelease(app);
}

int main(int argc, char **argv) {
  if (argc == 1) {
    printf("Usage: %s [-l | -c item_name | -i id]\n", argv[0]);
    printf("  -l: List all available menu items\n");
    printf("  -c item_name: Click on menu item containing the specified text\n");
    printf("  -i id: Click on menu item with the specified ID\n");
    printf("\nExamples:\n");
    printf("  %s -l\n", argv[0]);
    printf("  %s -c wifi\n", argv[0]);
    printf("  %s -c battery\n", argv[0]);
    printf("  %s -i 2\n", argv[0]);
    exit(0);
  }

  ax_init();

  if (strcmp(argv[1], "-l") == 0) {
    list_menu_items();
  } else if (argc == 3 && strcmp(argv[1], "-c") == 0) {
    if (!click_menu_item_by_description(argv[2])) {
      printf("Menu item containing '%s' not found\n", argv[2]);
      return 1;
    }
  } else if (argc == 3 && strcmp(argv[1], "-i") == 0) {
    int id = atoi(argv[2]);
    if (!click_menu_item_by_id(id)) {
      return 1;
    }
  } else {
    printf("Unknown option: %s\n", argv[1]);
    return 1;
  }

  return 0;
}
