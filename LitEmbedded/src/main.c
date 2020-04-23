#include <stdio.h>
#include <pthread.h>
#include <signal.h>
#include <unistd.h>
#include "timer.h"


int main(int argc, char* argv[]){
  nb_buffer = 0;
  pthread_cond_init(&new_frame, NULL);
  signal(SIGALRM, sigalarm_handler);
  alarm(1);
  while(1){
    //do shit
  }
  return 0;
}
