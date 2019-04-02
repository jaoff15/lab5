/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"
#include "xbram.h"
#include "xil_io.h"


void render(u8 x, u8 y, u8 r, u8 g, u8 b);
void clearMemory();



int main()
{
    init_platform();

    clearMemory();


	for(u8 col = 0; col < 8; col++){
		for(u8 row = 0; row < 8; row++){
			render(col, row, row*10,col*10,0);
//			render(col, row, 100,100,0);
		}
	}
//    render(0, 0, 0, 200, 0);


//    Xil_Out32(XPAR_BRAM_0_BASEADDR, 0x000000FF);

    cleanup_platform();
    return 0;
}




// Function to reset memory
void clearMemory(){
	for(u8 col = 0; col < 8; col++){
		for(u8 row = 0; row < 8; row++){
			render(col, row, 0, 0, 0);
		}
	}
}


// Function to render a pixel to the display
void render(u8 x, u8 y, u8 r, u8 g, u8 b){
	u32 Addr = XPAR_BRAM_0_BASEADDR + x*4 + y*32;
	u32 value = 0x00000000;
	value +=(r << 16);
	value +=(g << 8);
	value +=(b);
	Xil_Out32(Addr, value);
}
