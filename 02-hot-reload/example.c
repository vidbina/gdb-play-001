#include <stdbool.h>
#include <stdio.h>

int
main(void)
{
  bool verbose = true;
  bool letsGetOut = false;

  int i = 0;
  for(i = 0; i < 128; i++)
  {
    if(verbose) {
      printf("[%3d]", i);
    } else {
      printf(".");
    }

    if(letsGetOut) break;
  }
}
