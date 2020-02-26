#include <pthread.h>
#include <unistd.h>
#include <stdio.h>
#include "timer.h"

volatile sig_atomic_t nb_buffer = 0;
pthread_cond_t new_frame;

void sigalarm_handler(int signal){
  printf("bleh\n");
  nb_buffer = 1 - nb_buffer;
  pthread_cond_signal(&new_frame);
  alarm(1);
}
