/*
 * led_matrix.c
 *
 *  Created on: Apr 2, 2019
 *      Author: jacoboffersen
 */

#include "led_matrix.h"



// Initialize the LED matrix
void initLedMatrix(){
	resetAllPixels();
	writeAllPixelToDevice();
}

// Function to reset memory
void resetAllPixels(){
	for(u8 y = 0; y < 8; y++){
		for(u8 x = 0; x < 8; x++){
			setPixelValue(x, y, 0, 0, 0);
		}
	}
}

// Writes r, g and b colors to the specified x,y pixel
void setPixelValue(u8 x, u8 y, u8 r, u8 g, u8 b){
	matrix[x][y][R] = r;
	matrix[x][y][G] = g;
	matrix[x][y][B] = b;
}

// Write the col specified by the col struct to the position specified
void setPixel(position_t pos, color_t col){
	matrix[pos.x][pos.y][R] = col.r;
	matrix[pos.x][pos.y][G] = col.g;
	matrix[pos.x][pos.y][B] = col.b;
}
void getPixel(position_t pos, color_t *col){
	col->r = matrix[pos.x][pos.y][R];
	col->g = matrix[pos.x][pos.y][G];
	col->b = matrix[pos.x][pos.y][B];
}

// Decrement specified pixel
void decrementPixel(position_t pos){
	color_t col;
	u8 fadeFactor = 1;
	getPixel(pos, &col);
	if(col.r >= fadeFactor){
		col.r -= fadeFactor;
	}
	else{
		col.r = 0;
	}
	if(col.g >= fadeFactor){
		col.g -= fadeFactor;
	}
	else{
		col.g = 0;
	}
	if(col.b >= fadeFactor){
		col.b -= fadeFactor;
	}
	else{
		col.b = 0;
	}
	setPixel(pos, col);
}

// Writes the specified pixel to the device
void writePixelToDevice(position_t pos){
	u8 r = matrix[pos.x][pos.y][R];
	u8 g = matrix[pos.x][pos.y][G];
	u8 b = matrix[pos.x][pos.y][B];
	u32 addr = XPAR_BRAM_0_BASEADDR + pos.x*4 + pos.y*32;
	u32 value = (r << 16) + (g << 8) + b;
	ledMatrixOut(addr, value);
}

// Writes all pixel values to the device
void writeAllPixelToDevice(){
	position_t pos;
	for(u8 y = 0; y < 8; y++){
		for(u8 x = 0; x < 8; x++){
			pos.x = x;
			pos.y = y;
			writePixelToDevice(pos);
		}
	}
}

// Write pixel value to the LED matrix
void ledMatrixOut(u32 addr, u32 data){
	Xil_Out32(addr, data);
}



