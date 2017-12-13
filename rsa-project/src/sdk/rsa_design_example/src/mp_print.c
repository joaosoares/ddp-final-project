#include "xil_printf.h"

void mp_print(uint32_t *a, char *name, int size) {
  int i;
  xil_printf("%s = ", name);
  for (i = 0; i < size; i++) {
    xil_printf("%08x", a[size - i - 1]);
  }
  xil_printf("\n\r");
}