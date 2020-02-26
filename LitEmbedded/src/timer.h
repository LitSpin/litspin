#ifndef TIMER_H
#define TIMER_H

#include <signal.h>
#include <pthread.h>


extern volatile sig_atomic_t nb_buffer;
extern pthread_cond_t new_frame;


void sigalarm_handler(int signal);

#endif
