#include <stdbool.h>
#include <stdio.h>

void sort(long* array) {
  int i = 0;
  bool sorted;

  do {
    sorted = true;

    for(i=0; i < 31; i++) {
      long* item_one = &array[i];
      long* item_two = &array[i+1];
      long swap_store;
      if(*item_one <= *item_two) {
        continue;
      }

      sorted = false;
      swap_store = *item_two;
      *item_two = *item_one;
      *item_one = swap_store;
    }
  } while(!sorted);
}

int main () {
  long array[32];
  int i = 0;

  srand(time(NULL));
  int x = rand() % sizeof array;
  printf("x=%d\n", x);
  for(i = 0; i < x; i++) {
    // TODO: figure out why this doesn't segfault
    // upon access to array[n] where n>=32
    array[i] = rand();
    printf("i %4d=%4d\n", i, array[i]);
  }

  sort(array);

  return 0;
}
