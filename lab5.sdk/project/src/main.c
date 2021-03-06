
#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "led_matrix.h"
#include <math.h>
#include <stdlib.h>

#define MIN_X 0
#define MAX_X 7
#define MIN_Y 0
#define MAX_Y 7
#define MIN_R 50
#define MAX_R 255
#define MIN_G 50
#define MAX_G 255
#define MIN_B 50
#define MAX_B 100


int main()
{
    init_platform();

    initLedMatrix();

    //fadingDots();
    //runningLed();
    //randomPixel();
    gradient();



    cleanup_platform();
    return 0;
}

void fadingDots(){
	position_t pos;
	while(1){
		for(u8 iter = 0; iter < 20; iter++){
			for(u8 y = 0; y < 8; y++){
				for(u8 x = 0; x < 8; x++){
					pos.x = x;
					pos.y = y;
					decrementPixel(pos);
				}
			}
			writeAllPixelToDevice();
			usleep(MS_10);
		}
		pos.x = floor(rand() % MAX_X + MIN_X);
		pos.y = floor(rand() % MAX_Y + MIN_Y);
		setPixel(pos,RED);
	}
}


void runningLed(){
	position_t pos;
	direction_t dir = UP;
	while(1){

		for(u8 y = 0; y < 8; y++){
			for(u8 x = 0; x < 8; x++){
				switch(dir){
				case UP:
					pos.x = 7 - x;
					pos.y = 7 - y;
					break;
				case LEFT:
					pos.x = y;
					pos.y = x;
					break;
				case DOWN:
					pos.x = x;
					pos.y = y;
					break;
				case RIGHT:
					pos.x = 7 - y;
					pos.y = 7 - x;
					break;
				default:
					dir = DOWN;
				}
				setPixel(pos, YELLOW);
				writePixelToDevice(pos);
				usleep(MS_500);
				setPixel(pos, NONE);
				writePixelToDevice(pos);
			}
		}
		dir++;
		// Overflow control
		if(dir == 4){
			dir = UP;
		}
	}
}


void randomPixel(){
    position_t pos;
    color_t    col;
	while(1){
    	pos.x = floor(rand() % MAX_X + MIN_X);
    	pos.y = floor(rand() % MAX_Y + MIN_Y);
    	col.r = floor(rand() % MAX_R + MIN_R);
    	col.g = floor(rand() % MAX_G + MIN_G);
    	col.b = floor(rand() % MAX_B + MIN_B);
    	resetAllPixels();
    	setPixel(pos,col);
    	writeAllPixelToDevice();
    	usleep(SEC_1);

    }
}

void gradient(){
	for(u8 y = 0; y < 8; y++){
		for(u8 x = 0; x < 8; x++){
			setPixelValue(y, x, x*10, y*10, 0);
		}
	}
	writeAllPixelToDevice();
}

