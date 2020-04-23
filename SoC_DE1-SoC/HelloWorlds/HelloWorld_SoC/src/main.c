#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include "hwlib.h"
#include "soc_cv_av/socal/socal.h"
#include "soc_cv_av/socal/hps.h"
#include "soc_cv_av/socal/alt_gpio.h"
#include "hps_0.h"

#define HW_REGS_BASE ( ALT_STM_OFST )
#define HW_REGS_SPAN ( 0x04000000 )
#define HW_REGS_MASK ( HW_REGS_SPAN - 1 )


int main() {

	void *virtual_base;
	int fd;
	volatile unsigned int *led_addr;
    volatile unsigned int *sw_addr;
    volatile unsigned int *seg_addr;
    volatile unsigned int *key_addr;



    // Virtual address mapping

	// map the address space for the LED registers into user space so we can interact with them.
	// we'll actually map in the entire CSR span of the HPS since we want to access various registers within that span

	if( ( fd = open( "/dev/mem", ( O_RDWR | O_SYNC ) ) ) == -1 ) {
		printf( "ERROR: could not open \"/dev/mem\"...\n" );
		return( 1 );
	}

	virtual_base = mmap( NULL, HW_REGS_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, HW_REGS_BASE );

	if( virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap() failed...\n" );
		close( fd );
		return( 1 );
	}
	
	led_addr=virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + LEDS_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
    sw_addr=virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + SW_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
    seg_addr=virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + OSEG_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
    key_addr=virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + KEY_BASE ) & ( unsigned long)( HW_REGS_MASK ) );

    int compteur = 0;

    while ((*key_addr) & 0b1){


        usleep(100*1000);

        if (!((*key_addr) & 0b100))
            compteur++;
        if (!((*key_addr) & 0b10))
            compteur--;

        seg_addr[0] = compteur % 0x10;
        seg_addr[1] = compteur / 0x10; 

        *led_addr = *sw_addr;

    }

	// clean up our memory mapping and exit
	
	if( munmap( virtual_base, HW_REGS_SPAN ) != 0 ) {
		printf( "ERROR: munmap() failed...\n" );
		close( fd );
		return( 1 );
	}

	close( fd );

	return( 0 );
}


