/*
 * led_matrix.h
 *
 *  Created on: Apr 2, 2019
 *      Author: jacoboffersen
 */

#ifndef SRC_LED_MATRIX_H_
#define SRC_LED_MATRIX_H_

#include "xparameters.h"
#include "xbram.h"
#include "xil_io.h"
#include "types.h"



u8 matrix[8][8][3];


// Initialize the LED matrix
void initLedMatrix();

// Function to reset memory
void clearMemory();




void setPixelValue(u8 x, u8 y, u8 r, u8 g, u8 b);

void setPixel(position_t pos, color_t col);


void writePixelToDevice(position_t pos);


void writeAllPixelToDevice();
//void setPixelValueOnDevice(u8 x, u8 y, u8 r, u8 g, u8 b);
//void setPixelOnDevice(position_t pos, color_t col);


// Write pixel value to the LED matrix
void ledMatrixOut(u32 addr, u32 data);


#endif /* SRC_LED_MATRIX_H_ */
