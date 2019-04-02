
#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "led_matrix.h"





int main()
{
    init_platform();

    initLedMatrix();

	for(u8 col = 0; col < 8; col++){
		for(u8 row = 0; row < 8; row++){
			setPixelValue(col, row, row*10, col*10, 0);
		}
	}
	writeAllPixelToDevice();

    cleanup_platform();
    return 0;
}


