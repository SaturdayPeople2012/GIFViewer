//
//  GIF_Library.h
//  GIFViewer
//
//  Created by 태상 조 on 12. 10. 28..
//  Copyright (c) 2012년 양원석. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "GIF_Header.h"

@interface GifQueueObject : NSObject

@property (nonatomic, strong) NSString* m_filePath;
@property (nonatomic, strong) UIImageView* m_view;

@end

@interface GIF_Library : NSObject
{
    NSMutableArray* m_gif_queue;
        
    NSData*     m_gif_disk;                // GIF 파일의 디스크 이미지
    int         m_gif_offset;              // GIF 파일의 포인터

    GIF_HEADER	m_gif_hdr;
    GIF_GRAPHIC_CONTROL_EXTENSION_BLOCK m_gif_gceb;
    
    int         m_gif_gctf;                // Global Color Table Flag(GCDF)
    int         m_gif_sorted;
    int         m_gif_colorb;
    int         m_gif_colors;
    
    NSMutableData* m_gif_global_color_table;
    NSMutableArray* m_gif_delays;
    NSMutableArray* m_gif_frames;
}

@property bool m_busyInstance;
@property (nonatomic, strong) UIImageView* m_gifView;
@property (nonatomic, strong) void (^m_blockCompletion)(int width,int height);
@property (nonatomic, strong) UIViewController* m_parentVC;

/*
 ///////////////////////////////////////////////////////////////////////////////////////////////////////////
 */

+ (UIImageView*) giflib_get_gif_view_from_path:(NSString*) filePath parent:(UIViewController*) parent completion:(void(^)(int width,int height)) completion;

@end
