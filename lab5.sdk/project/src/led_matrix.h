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


// 3-dimentional array that contains the three different colors
u8 matrix[8][8][3];

// Initialize the LED matrix
void initLedMatrix();

// Function to reset memory
void resetAllPixels();

// Writes r, g and b colors to the specified x,y pixel
void setPixelValue(u8 x, u8 y, u8 r, u8 g, u8 b);

// Write the col specified by the col struct to the position specified
void setPixel(position_t pos, color_t col);
void getPixel(position_t pos, color_t *col);

// Decrement specified pixel
void decrementPixel(position_t pos);

// Writes the specified pixel to the device
void writePixelToDevice(position_t pos);

// Writes all pixel values to the device
void writeAllPixelToDevice();

// Write pixel value to the LED matrix
void ledMatrixOut(u32 addr, u32 data);


#endif /* SRC_LED_MATRIX_H_ */
