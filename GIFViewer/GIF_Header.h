//
//  GIF_Header.h
//  GIFViewer
//
//  Created by CHO,TAE-SANG on 12. 10. 30..
//  Copyright (c) 2012년 CHO,TAE-SANG. All rights reserved.
//

#ifndef GIFViewer_GIF_Header_h
#define GIFViewer_GIF_Header_h

/*
 ///// GIF File header ///////////////////////////////////////////////
 */

#pragma pack(push,1)

typedef struct {
	u_char		Signature[6];
	u_short		logical_screen_width;
	u_short		logical_screen_height;
	u_char		flags;
	u_char		background_color_index;
	u_char 		pixel_aspect_ratio;
} GIF_HEADER;

typedef struct {
	u_char		introducer;
	u_char		label;
	u_char		size;
	u_char		identifier[0];
} GIF_APPLICATION_EXTENSION_BLOCK;

typedef struct {
	u_char		introducer;
	u_char		label;
	u_char		size;
	u_char		flag;
	u_short		delay;
	u_char		trans_color;
	u_char		terminator;
} GIF_GRAPHIC_CONTROL_EXTENSION_BLOCK;

typedef struct {
	u_char		introducer;
	u_char		label;
	u_char		size;
	u_short		left_position;
	u_short		top_position;
	u_short		text_grid_width;
	u_short		text_grid_height;
	u_char		cell_width;
	u_char		cell_height;
	u_char		forground_color;
	u_char		background_color;
} GIF_PLAIN_TEXT_EXTENSION_BLOCK;

typedef struct {
	u_char		introducer;
	u_char		label;
} GIF_COMMENT_EXTENSION_BLOCK;

typedef struct {
	u_char		introducer;
	u_short		left_position;
	u_short		top_position;
	u_short		width;
	u_short		height;
	u_char		flags;
} GIF_IMAGE_BLOCK;

#pragma pack(pop)


#endif
