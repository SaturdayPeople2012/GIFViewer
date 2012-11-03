//
//  GIF_Library.m
//  GIFViewer
//
//  Created by 태상 조 on 12. 10. 28..
//  Copyright (c) 2012년 양원석. All rights reserved.
//

#import "GIF_Library.h"

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

+ (UIImageView*) giflib_get_gif_view_from_url:(NSURL*) gifUrl completion:(void(^)(int width,int height)) completion
{
    GifQueueObject* qitem = [[GifQueueObject alloc] init];
    
    qitem.m_url = gifUrl;
    qitem.m_view = [[UIImageView alloc] init];
    
    GIF_Library* inst = [GIF_Library giflib_sharedInstance];
    
    [inst giflib_add_to_queue: qitem];
    inst.m_blockCompletion = completion;
    
    if (inst.m_busyInstance != TRUE)
    {
        inst.m_busyInstance = TRUE;
        
        [inst performSelector:@selector(giflib_async_loader) withObject:nil];
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
        NSLog(@"%@",((GifQueueObject*)[m_gif_queue objectAtIndex:0]).m_url);
        NSData* data = [NSData dataWithContentsOfURL:((GifQueueObject*)[m_gif_queue objectAtIndex:0]).m_url];
        self.m_gifView = ((GifQueueObject*)[m_gif_queue objectAtIndex:0]).m_view;
        
        [self giflib_decode:data];
        
        UIImageView* imageView = [self gif_get_animation];
        [self.m_gifView setImage:[imageView image]];
        [self.m_gifView sizeToFit];
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
    
    NSLog(@"logical_screen_width = %d",m_gif_hdr.logical_screen_width);
    NSLog(@"logical_screen_height = %d",m_gif_hdr.logical_screen_height);
    
//    self.m_blockCompletion(m_gif_hdr.logical_screen_width,m_gif_hdr.logical_screen_height);
    
    m_gif_gctf   = (m_gif_hdr.flags & 0x80) ? 1 : 0;
    m_gif_sorted = (m_gif_hdr.flags * 0x08) ? 1 : 0;
    m_gif_colorb = (m_gif_hdr.flags & 0x07);
    m_gif_colors = 2 << m_gif_colorb;
    
    NSLog(@"gif_gctf = %d, gif_colors = %d",m_gif_gctf,m_gif_colors);
    
    if (m_gif_gctf)
    {
        m_gif_global_color_table = [self giflib_get_n_bytes: (3 * m_gif_colors)];
        if (m_gif_global_color_table == nil) return;
    }
    
//    NSLog(@"global color table = %@",m_gif_global_color_table);
    
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
						[self giflib_plain_text_extension_block];
						break;
					case 0xf9:// Graphic Control Extension Block
						m_gif_offset -= 2;
						[self giflib_graphic_control_extension_block];
						break;
					case 0xfe:	// Comment Extension Block
						m_gif_offset -= 2;
						[self giflib_comment_extension_block];
						break;
					case 0xff:// Application Extension Block
						m_gif_offset -= 2;
						[self giflib_application_extension_block];
						break;
					default:
						NSLog(@"[OOPS!:Unknown Extension(0x%X)]",u8);
						return;
                }
                break;
			case 0x2c:// Image Block
				m_gif_offset -= 1;
				[self giflib_image_block];
				break;
			case 0x3b:// Trailer
				NSLog(@"[END]");
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
    
    [m_gif_delays addObject:[NSNumber numberWithInt: m_gif_gceb.delay]];
    
    NSLog(@"delay = %d",m_gif_gceb.delay);
}

-(void) giflib_comment_extension_block
{
    GIF_COMMENT_EXTENSION_BLOCK b;

    if ([self giflib_get_n_bytes:&b length:sizeof(b)] < 0) return;

    u_char  u8;
    
    while ([self giflib_get_8bits:&u8] > 0 && u8 > 0)
    {
        m_gif_offset += u8;
    }
}

-(void) giflib_application_extension_block
{
    GIF_APPLICATION_EXTENSION_BLOCK b;
    
    if ([self giflib_get_n_bytes:&b length:sizeof(b)] < 0) return;
    
    NSMutableData* app_id;
    
    app_id = [self giflib_get_n_bytes:b.size];
    if (app_id == nil) return;
    
    NSLog(@"application id = %@",app_id);
        
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
    
    NSLog(@"image block : position = (%d,%d)-(%d,%d)",b.left_position,b.top_position,b.width,b.height);
    
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
    
    u_char temp;
    
    [self giflib_get_8bits:&temp];
    [gif_data appendBytes:&temp length:sizeof(temp)];
    
    while (true)
    {
        [self giflib_get_8bits:&temp];
        [gif_data appendBytes:&temp length:sizeof(temp)];
        
        if (temp != 0)
        {
            NSMutableData* line = [self giflib_get_n_bytes:temp];
            [gif_data appendData:line];
        } else break;
    }
    
    temp = 0x3b; // Trailer
    [gif_data appendBytes:&temp length:sizeof(temp)];
    
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

- (UIImageView*) gif_get_animation
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

@end
