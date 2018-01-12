#include <stdbool.h>
#include <stdio.h>

int
main(void)
{
  printf("one ");
  printf("two ");
  printf("three ");
  printf("four ");

  int i = 0;
  bool verbose = true;

  for(i = 0; i < 10; i++)
  {
    if(verbose == true)
    {
      printf("i = %3d\n", i);
    }
  }
}
