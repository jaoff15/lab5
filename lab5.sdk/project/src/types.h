/*
 * types.h
 *
 *  Created on: Apr 2, 2019
 *      Author: jacoboffersen
 */

#ifndef SRC_TYPES_H_
#define SRC_TYPES_H_



typedef struct position_t{
	u8 x;
	u8 y;
} position_t;

typedef struct color_t{
	u8 r;
	u8 g;
	u8 b;
} color_t;

#define RED 	0
#define GREEN 	1
#define BLUE 	2

#endif /* SRC_TYPES_H_ */
