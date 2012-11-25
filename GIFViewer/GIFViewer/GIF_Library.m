//
//  GIF_Library.m
//  GIFViewer
//
//  Created by 조 태상 on 12. 10. 28..
//  Copyright (c) 2012년 조 태상. All rights reserved.
//

#import "GIF_Library.h"

#define __PRINT_NSLOG__

@implementation GifQueueObject

@end

@implementation GIF_Library

static GIF_Library* instance;

+ (GIF_Library*) giflib_sharedInstance
{
    if (instance == nil)
    {
        instance = [[GIF_Library alloc] init];
    }
    
    return instance;
}

+ (UIImageView*) giflib_get_gif_view_from_path:(NSString*) filePath parent:(UIViewController*) parent completion:(void(^)(int width,int height)) completion
{
    GifQueueObject* qitem = [[GifQueueObject alloc] init];
    
    qitem.m_filePath = filePath;
    qitem.m_view = [[UIImageView alloc] init];
    
    GIF_Library* inst = [GIF_Library giflib_sharedInstance];
    
    [inst giflib_add_to_queue: qitem];
    inst.m_parentVC = parent;
    inst.m_blockCompletion = completion;
    
    if (inst.m_busyInstance != TRUE)
    {
        inst.m_busyInstance = TRUE;

        [inst performSelector:@selector(giflib_async_loader) withObject:nil afterDelay:0.0];
    }
    
    return qitem.m_view;
}

- (id) init
{
    if (self = [super init])
    {
        m_gif_queue = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) giflib_add_to_queue: (GifQueueObject *) item
{
    [m_gif_queue addObject: item];
}

- (void) giflib_async_loader
{
    while ([m_gif_queue count] > 0)
    {
#ifdef __PRINT_NSLOG__
        NSLog(@"%@",((GifQueueObject*)[m_gif_queue objectAtIndex:0]).m_filePath);
#endif
        NSData* data = [NSData dataWithContentsOfFile:((GifQueueObject*)[m_gif_queue objectAtIndex:0]).m_filePath];
        self.m_gifView = ((GifQueueObject*)[m_gif_queue objectAtIndex:0]).m_view;

        NSLog(@"data length = %d",[data length]);
        
        [self giflib_decode:data];
        
        UIImageView* imageView = [self giflib_get_animation];
        [self.m_gifView setImage:[imageView image]];
//      [self.m_gifView sizeToFit];
        [self.m_gifView setAnimationImages:[imageView animationImages]];
        [self.m_gifView startAnimating];
        
        [m_gif_queue removeObjectAtIndex:0];
    }
    
    self.m_busyInstance = FALSE;
}

/*
 /////////////////////////////////////////////////////////////////////////////////////////////////
 */

- (int) giflib_get_n_bytes: (void*)target length:(int)length
{
    if ([m_gif_disk length] >= (m_gif_offset + length))
    {
        [m_gif_disk getBytes:target range:NSMakeRange(m_gif_offset, length)];
        
        m_gif_offset += length;
        
        return 1;
    } else
    {
        return -1;
    }
}

- (int) giflib_get_8bits: (u_char*) target
{
    if ([m_gif_disk length] >= (m_gif_offset + sizeof(u_char)))
    {
        [m_gif_disk getBytes:target range:NSMakeRange(m_gif_offset, sizeof(u_char))];
        
        m_gif_offset += sizeof(u_char);
        
        return 1;
    } else
    {
        return -1;
    }
}

- (int) giflib_get_16bits: (u_short*) target
{
    if ([m_gif_disk length] >= (m_gif_offset + sizeof(u_short)))
    {
        [m_gif_disk getBytes:target range:NSMakeRange(m_gif_offset, sizeof(u_short))];
        
        m_gif_offset += sizeof(u_short);
        
        return 1;
    } else
    {
        return -1;
    }
}

- (NSMutableData*) giflib_get_n_bytes:(int)length
{
    NSMutableData* target;
    
    target = [[NSMutableData alloc] init];
        
    if ([m_gif_disk length] >= (m_gif_offset + length))
    {
        target = (NSMutableData*)[m_gif_disk subdataWithRange:NSMakeRange(m_gif_offset, length)];
        
        m_gif_offset += length;
        
        return target;
    } else
    {
        return nil;
    }
}

/*
 /////////////////////////////////////////////////////////////////////////////////////////////////
 */

- (void) giflib_decode:(NSData*)data
{
    ////////////////////////////////////////////////////////////////////////

    m_gif_disk = data;
    m_gif_offset = 0;
    
    m_gif_global_color_table = nil;
    m_gif_delays = nil;
    m_gif_frames = nil;
    
    m_gif_delays = [[NSMutableArray alloc] init];
    m_gif_frames = [[NSMutableArray alloc] init];
        
    ////////////////////////////////////////////////////////////////////////
    
	if ([self giflib_get_n_bytes:&m_gif_hdr length:sizeof(m_gif_hdr)] < 0) return;
    
#ifdef __PRINT_NSLOG__
    NSLog(@"logical_screen_width = %d",m_gif_hdr.logical_screen_width);
    NSLog(@"logical_screen_height = %d",m_gif_hdr.logical_screen_height);
#endif
    
    self.m_blockCompletion(m_gif_hdr.logical_screen_width,m_gif_hdr.logical_screen_height);
    
    m_gif_gctf   = (m_gif_hdr.flags & 0x80) ? 1 : 0;
    m_gif_sorted = (m_gif_hdr.flags * 0x08) ? 1 : 0;
    m_gif_colorb = (m_gif_hdr.flags & 0x07);
    m_gif_colors = 2 << m_gif_colorb;
    
#ifdef __PRINT_NSLOG__
    NSLog(@"gif_gctf = %d, gif_colors = %d",m_gif_gctf,m_gif_colors);
#endif
    
    if (m_gif_gctf)
    {
        m_gif_global_color_table = [self giflib_get_n_bytes: (3 * m_gif_colors)];
        if (m_gif_global_color_table == nil) return;
    }
    
#ifdef __PRINT_NSLOG__
    NSLog(@"global color table = %@",m_gif_global_color_table);
#endif
    
    u_char  u8;
    
    while ([self giflib_get_8bits:&u8] > 0)
    {
        switch (u8)
        {
            case 0x21: // Extension Block
                if ([self giflib_get_8bits:&u8] < 0) return;
                switch (u8)
                {
					case 0x01:// Plain Text Extension Block
						m_gif_offset -= 2;
#ifdef __PRINT_NSLOG__
                        NSLog(@"[PLAIN_TEXT_EXTENSION_BLOCK]");
#endif
						[self giflib_plain_text_extension_block];
						break;
					case 0xf9:// Graphic Control Extension Block
						m_gif_offset -= 2;
#ifdef __PRINT_NSLOG__
                        NSLog(@"[GRAPHIC_CONTROL_EXTENSION_BLOCK]");
#endif
						[self giflib_graphic_control_extension_block];
						break;
					case 0xfe:	// Comment Extension Block
						m_gif_offset -= 2;
#ifdef __PRINT_NSLOG__
                        NSLog(@"[COMMENT_EXTENSION_BLOCK]");
#endif
						[self giflib_comment_extension_block];
						break;
					case 0xff:// Application Extension Block
						m_gif_offset -= 2;
#ifdef __PRINT_NSLOG__
                        NSLog(@"[APPLICATION_EXTENSION_BLOCK]");
#endif
						[self giflib_application_extension_block];
						break;
					default:
						NSLog(@"[OOPS!:Unknown Extension(0x%X)]",u8);
						return;
                }
                break;
			case 0x2c:// Image Block
				m_gif_offset -= 1;
#ifdef __PRINT_NSLOG__
				NSLog(@"[IMAGE_BLOCK]");
#endif
				[self giflib_image_block];
				break;
			case 0x3b:// Trailer
#ifdef __PRINT_NSLOG__
				NSLog(@"[END]");
#endif
				return;
			default:
				NSLog(@"[OOPS!:Unknown introducer(0x%X)]",u8);
				return;
        }
    }
}

-(void) giflib_plain_text_extension_block
{
    GIF_PLAIN_TEXT_EXTENSION_BLOCK b;
    
    if ([self giflib_get_n_bytes:&b length:sizeof(b)] < 0) return;
    
    u_char  u8;
    
    while ([self giflib_get_8bits:&u8] > 0 && u8 > 0)
    {
        m_gif_offset += u8;
    }
}

-(void) giflib_graphic_control_extension_block
{
    if ([self giflib_get_n_bytes:&m_gif_gceb length:sizeof(m_gif_gceb)] < 0) return;
    
    if (m_gif_gceb.delay == 0) [m_gif_delays addObject:[NSNumber numberWithInt:10]];
    else                       [m_gif_delays addObject:[NSNumber numberWithInt: m_gif_gceb.delay]];

#ifdef __PRINT_NSLOG__
    NSLog(@"delay = %d",m_gif_gceb.delay);
#endif
}

-(void) giflib_comment_extension_block
{
    GIF_COMMENT_EXTENSION_BLOCK b;

    if ([self giflib_get_n_bytes:&b length:sizeof(b)] < 0) return;

    u_char  u8;
    
    while ([self giflib_get_8bits:&u8] > 0 && u8 > 0)
    {
        NSMutableData* comment_t = [self giflib_get_n_bytes:u8];
        NSString* comment = [[NSString alloc] initWithData:comment_t encoding:NSUTF8StringEncoding];
        
        self.m_parentVC.title = comment;

#ifdef __PRINT_NSLOG__
        NSLog(@"u8 = %d, comment = \"%@\", length = %d",u8, comment_t,[comment_t length]);
#endif
    }
}

-(void) giflib_application_extension_block
{
    GIF_APPLICATION_EXTENSION_BLOCK b;
    
    if ([self giflib_get_n_bytes:&b length:sizeof(b)] < 0) return;
    
    NSMutableData* app_id;
    
    app_id = [self giflib_get_n_bytes:b.size];
    if (app_id == nil) return;
    
#ifdef __PRINT_NSLOG__
    NSLog(@"application id = %@",app_id);
#endif
        
    u_char  u8;
    
    while ([self giflib_get_8bits:&u8] > 0 && u8 > 0)
    {
        m_gif_offset += u8;
    }
}

-(void) giflib_image_block
{
    GIF_IMAGE_BLOCK b;
    
    if ([self giflib_get_n_bytes:&b length:sizeof(b)] < 0) return;
    
#ifdef __PRINT_NSLOG__
    NSLog(@"image block : position = (%d,%d)-(%d,%d)",b.left_position,b.top_position,b.width,b.height);
#endif
    
    int gif_lctf = (b.flags & 0x80) ? 1 : 0;
    
    int gif_colorb = m_gif_colorb;
    int gif_sorted = m_gif_sorted;
    
    if (gif_lctf)
    {
        gif_colorb = (b.flags & 0x07);
        gif_sorted = (b.flags & 0x20) ? 1 : 0;
    }
    
    int gif_colors = (2 << gif_colorb);
    
    m_gif_hdr.flags = (m_gif_hdr.flags & 0x70);
    m_gif_hdr.flags = (m_gif_hdr.flags | 0x80);
    m_gif_hdr.flags = (m_gif_hdr.flags | gif_colorb);
    
    if (gif_sorted) m_gif_hdr.flags |= 0x08;
    
    NSMutableData* gif_data = [[NSMutableData alloc] init];
    
    [gif_data appendBytes:&m_gif_hdr length:sizeof(m_gif_hdr)];
    
    if (gif_lctf)
    {
        NSMutableData* gif_lct = [self giflib_get_n_bytes: (3 * gif_colors)];
        if (gif_lct == nil) return;
        [gif_data appendData:gif_lct];
    } else
    {
        [gif_data appendData:m_gif_global_color_table];
    }
    
    [gif_data appendBytes:&m_gif_gceb length:sizeof(m_gif_gceb)];
    
    b.flags &= 0x40;    // Interlace Flag
    
    [gif_data appendBytes:&b length:sizeof(b)];
    
    u_char u8;
    
    if ([self giflib_get_8bits:&u8] < 0) return;
    [gif_data appendBytes:&u8 length:sizeof(u8)];
    
    while (true)
    {
        if ([self giflib_get_8bits:&u8] < 0) return;
        [gif_data appendBytes:&u8 length:sizeof(u8)];
        
        if (u8 != 0)
        {
            NSMutableData* line = [self giflib_get_n_bytes:u8];
            if (line == nil) return;
            [gif_data appendData:line];
        } else break;
    }
    
    u8 = 0x3b; // Trailer
    [gif_data appendBytes:&u8 length:sizeof(u8)];
    
    [m_gif_frames addObject:[gif_data copy]];
}

- (UIImage*) giflib_get_frame_as_image_index:(int)index
{
    NSData* frameData = (index < [m_gif_frames count]) ? [m_gif_frames objectAtIndex:index] : nil;
    UIImage* image = nil;
    
    if (frameData != nil)
    {
        image = [UIImage imageWithData:frameData];
    }
    
    return image;
}

- (UIImageView*) giflib_get_animation
{
    if ([m_gif_frames count] > 0)
    {
        if (self.m_gifView != nil)
        {
            [self.m_gifView setImage:[self giflib_get_frame_as_image_index:0]];
        } else
        {
            self.m_gifView = [[UIImageView alloc] initWithImage:[self giflib_get_frame_as_image_index:0]];
        }

		// Add all subframes to the animation
		NSMutableArray *array = [[NSMutableArray alloc] init];
		for (int i = 0; i < [m_gif_frames count]; i++)
		{
			[array addObject: [self giflib_get_frame_as_image_index:i]];
		}
		
		[self.m_gifView setAnimationImages:array];
		
		// Count up the total delay, since Cocoa doesn't do per frame delays.
		double total = 0;
		for (int i = 0; i < [m_gif_delays count]; i++)
		{
			total += [[m_gif_delays objectAtIndex:i] doubleValue];
		}
                
#ifdef __PRINT_NSLOG__
        NSLog(@"total delay = %f",total);
#endif
		
		// GIFs store the delays as 1/100th of a second,
        // UIImageViews want it in seconds.
		[self.m_gifView setAnimationDuration:total/100];
		
		// Repeat infinite
		[self.m_gifView setAnimationRepeatCount:0];
		
        [self.m_gifView startAnimating];
        
		return self.m_gifView;        
    } else
    {
        return nil;
    }
}

/*
 /////////////////////////////////////////////////////////////////////////////////////////////////
 */

-(void) giflib_copy_gif_hdeader:(NSMutableData*) target
{
    GIF_HEADER hdr;
    
    if ([self giflib_get_n_bytes:&hdr length:sizeof(hdr)] < 0) return;

    [target appendBytes:&hdr length:sizeof(hdr)];
    
    if (hdr.flags & 0x80)
    {
        int colors = 2 << (hdr.flags & 0x07);
        NSMutableData* t = [self giflib_get_n_bytes:(3 * colors)];
        if (t == nil) return;
        [target appendData:t];
    }
}

-(void) giflib_write_gif_comment_block:(NSMutableData*) target comment:(NSString*) comment
{
    GIF_COMMENT_EXTENSION_BLOCK b;
    
    b.introducer = 0x21;
    b.label = 0xfe;
    
    [target appendBytes:&b length:sizeof(b)];
    
#ifdef __PRINT_NSLOG__
    NSLog(@"(1)comment = %@",comment);
#endif
    
    char buffer[256] = { 0 };
    NSInteger length = [comment length];
    
    if (length > 255) length = 255;
    [comment getBytes:buffer maxLength:255 usedLength:NULL encoding:NSUTF8StringEncoding options:0 range:NSMakeRange(0, length) remainingRange:NULL];
    
    length = strlen(buffer);
    if (length > 255) length = 255;

#ifdef __PRINT_NSLOG__
    NSLog(@"(2)comment = %@, length = %d",[NSString stringWithCString:buffer encoding:NSUTF8StringEncoding],length);
#endif

    u_char  u8;
    
    u8 = length;
    [target appendBytes:&u8 length:sizeof(u8)];
    
    [target appendBytes:buffer length:length];

    u8 = 0;
    [target appendBytes:&u8 length:sizeof(u8)];
}

-(void) giflib_copy_plain_text_extension_block:(NSMutableData*) target
{
    GIF_PLAIN_TEXT_EXTENSION_BLOCK b;
    
    if ([self giflib_get_n_bytes:&b length:sizeof(b)] < 0) return;

    [target appendBytes:&b length:sizeof(b)];

    u_char  u8;
    
    while ([self giflib_get_8bits:&u8] > 0 && u8 > 0)
    {
        [target appendBytes:&u8 length:sizeof(u8)];
        NSMutableData* t = [self giflib_get_n_bytes:u8];
        if (t == nil) return;
        [target appendData:t];
    }

    u8 = 0;
    [target appendBytes:&u8 length:sizeof(u8)];
}

-(void) giflib_copy_graphic_control_extension_block:(NSMutableData*) target
{
    GIF_GRAPHIC_CONTROL_EXTENSION_BLOCK b;
    
    if ([self giflib_get_n_bytes:&b length:sizeof(b)] < 0) return;
    
    [target appendBytes:&b length:sizeof(b)];
}

-(void) giflib_skip_comment_extension_block:(NSMutableData*) target
{
    GIF_COMMENT_EXTENSION_BLOCK b;
    
    if ([self giflib_get_n_bytes:&b length:sizeof(b)] < 0) return;
    
    u_char  u8;
    
    while ([self giflib_get_8bits:&u8] > 0 && u8 > 0)
    {
        m_gif_offset += u8;
    }
}

-(void) giflib_copy_application_extension_block:(NSMutableData*) target
{
    GIF_APPLICATION_EXTENSION_BLOCK b;
    
    if ([self giflib_get_n_bytes:&b length:sizeof(b)] < 0) return;
    
    [target appendBytes:&b length:sizeof(b)];
    NSMutableData* t = [self giflib_get_n_bytes:b.size];
    if (t == nil) return;
    [target appendData:t];
    
    u_char  u8;
    
    while ([self giflib_get_8bits:&u8] > 0 && u8 > 0)
    {
        [target appendBytes:&u8 length:sizeof(u8)];
        t = [self giflib_get_n_bytes:u8];
        if (t == nil) return;
        [target appendData:t];
    }

    u8 = 0;
    [target appendBytes:&u8 length:sizeof(u8)];
}

-(void) giflib_copy_image_block:(NSMutableData*) target
{
    GIF_IMAGE_BLOCK b;
    
    if ([self giflib_get_n_bytes:&b length:sizeof(b)] < 0) return;
    
    [target appendBytes:&b length:sizeof(b)];

    if (b.flags & 0x80)
    {
        int colors = 2 << (b.flags & 0x07);
        NSMutableData* t = [self giflib_get_n_bytes:(3 * colors)];
        if (t == nil) return;
        [target appendData:t];
    }
        
    u_char u8;
    
    if ([self giflib_get_8bits:&u8] < 0) return;
    [target appendBytes:&u8 length:sizeof(u8)];
    
    while (true)
    {
        if ([self giflib_get_8bits:&u8] < 0) return;
        [target appendBytes:&u8 length:sizeof(u8)];
        
        if (u8 != 0)
        {
            NSMutableData* line = [self giflib_get_n_bytes:u8];
            if (line == nil) return;
            [target appendData:line];
        } else break;
    }
}

- (NSMutableData*) giflib_gif_copy_with_comment:(NSString*) comment
{
    NSMutableData* target;

    if (m_gif_disk == nil) return nil;

    m_gif_offset = 0;

    target = [[NSMutableData alloc] init];    
    
#ifdef __PRINT_NSLOG__
    NSLog(@"[HEADER]");
#endif
    [self giflib_copy_gif_hdeader: target];
    
#ifdef __PRINT_NSLOG__
    NSLog(@"[COMMENT_EXTENSION_BLOCK]");
#endif
    [self giflib_write_gif_comment_block: target comment: comment];
    
    u_char  u8;
    
    while ([self giflib_get_8bits:&u8] > 0)
    {
        switch (u8)
        {
            case 0x21: // Extension Block
                if ([self giflib_get_8bits:&u8] < 0) return nil;
                switch (u8)
                {
                    case 0x01:// Plain Text Extension Block
                        m_gif_offset -= 2;
#ifdef __PRINT_NSLOG__
                        NSLog(@"[PLAIN_TEXT_EXTENSION_BLOCK]");
#endif
                        [self giflib_copy_plain_text_extension_block: target];
                        break;
                    case 0xf9:// Graphic Control Extension Block
                        m_gif_offset -= 2;
#ifdef __PRINT_NSLOG__
                        NSLog(@"[GRAPHIC_CONTROL_EXTENSION_BLOCK]");
#endif
                        [self giflib_copy_graphic_control_extension_block: target];
                        break;
                    case 0xfe:	// Comment Extension Block
                        m_gif_offset -= 2;
#ifdef __PRINT_NSLOG__
                        NSLog(@"[COMMENT_EXTENSION_BLOCK]");
#endif
                        [self giflib_skip_comment_extension_block: target];
                        break;
                    case 0xff:// Application Extension Block
                        m_gif_offset -= 2;
#ifdef __PRINT_NSLOG__
                        NSLog(@"[APPLICATION_EXTENSION_BLOCK]");
#endif
                        [self giflib_copy_application_extension_block: target];
                        break;
                    default:
                        NSLog(@"[OOPS!:Unknown Extension(0x%X)]",u8);
                        return nil;
                }
                break;
			case 0x2c:// Image Block
				m_gif_offset -= 1;
#ifdef __PRINT_NSLOG__
				NSLog(@"[IMAGE_BLOCK]");
#endif
				[self giflib_copy_image_block: target];
				break;
			case 0x3b:// Trailer
#ifdef __PRINT_NSLOG__
				NSLog(@"[END]");
#endif
                u8 = 0x3b;
                [target appendBytes:&u8 length:sizeof(u8)];
                
				return target;
			default:
				NSLog(@"[OOPS!:Unknown introducer(0x%X)]",u8);
				return nil;
        }
    }    

    return nil;
}

@end
