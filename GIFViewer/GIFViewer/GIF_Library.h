//
//  AnimatedGif.h
//
//  Created by Stijn Spijker (http://www.stijnspijker.nl/) on 2009-07-03.
//  Based on gifdecode written april 2009 by Martin van Spanje, P-Edge media.
//  Modified by Shinya (https://github.com/kasatani/AnimatedGifExample) on 2010-05-20
//  Modified by Arturo Gutierrez to support Optimized Animate Gif with differentes Disposal Methods, 2011-03-12
//  Midified by CHO,TAE-SANG to support write Comment Extension Block, 2012-11-25 
//
//  Changes on gifdecode:
//  - Small optimizations (mainly arrays)
//  - Object Orientated Approach (Class Methods as well as Object Methods)
//  - Added the Graphic Control Extension Frame for transparancy
//  - Changed header to GIF89a
//  - Added methods for ease-of-use
//  - Added animations with transparancy
//  - No need to save frames to the filesystem anymore
//
//  Changelog:
//
//  2011-03-12: Support to Optimized Animated GIFs witch Disposal Methods: None, Restore and Background.
//	2010-03-16: Added queing mechanism for static class use
//  2010-01-24: Rework of the entire module, adding static methods, better memory management and URL asynchronous loading
//  2009-10-08: Added dealloc method, and removed leaks, by Pedro Silva
//  2009-08-10: Fixed double release for array, by Christian Garbers
//  2009-06-05: Initial Version
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#import <Foundation/Foundation.h>
#include "GIF_Header.h"

@interface AnimatedGifFrame : NSObject

@property (nonatomic, copy) NSData *header;
@property (nonatomic, copy) NSData *data;
@property (nonatomic) double delay;
@property (nonatomic) int disposalMethod;
@property (nonatomic) CGRect area;

@end

/*
 ///////////////////////////////////////////////////////////////////////////////////////////////////////////
 */

@interface GifQueueObject : NSObject

@property (nonatomic, strong) NSString* m_filePath;
@property (nonatomic, strong) UIImageView* m_view;

@end

/*
 ///////////////////////////////////////////////////////////////////////////////////////////////////////////
 */

@interface GIF_Library : NSObject
{
@public
    NSData*     m_gif_disk;                // GIF 파일의 디스크 이미지
    int         m_gif_offset;              // GIF 파일의 포인터
@private
    NSMutableArray* m_gif_queue;
    
    GIF_HEADER	m_gif_hdr;
    
    int         m_gif_gctf;                // Global Color Table Flag(GCDF)
    int         m_gif_sorted;
    int         m_gif_colorb;
    int         m_gif_colors;
    
    NSMutableData* m_gif_global_color_table;
    NSMutableArray* m_gif_frames;
}

@property bool m_busyInstance;
@property (nonatomic, strong) UIImageView* m_gifView;
@property (nonatomic, strong) void (^m_blockCompletion)(int width,int height);
@property (nonatomic, strong) UIViewController* m_parentVC;

/*
 ///////////////////////////////////////////////////////////////////////////////////////////////////////////
 */

+ (GIF_Library*) giflib_sharedInstance;

+ (UIImageView*) giflib_get_gif_view_from_path:(NSString*) filePath parent:(UIViewController*) parent completion:(void(^)(int width,int height)) completion;

- (NSMutableData*) giflib_gif_copy_with_comment:(NSString*) comment;

@end
