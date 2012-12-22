//
//  GIFDetailViewController.h
//  GIFViewer
//
//  Created by CHO,TAE-SANG on 12. 10. 22..
//  Copyright (c) 2012년 CHO,TAE-SANG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GIF_Library.h"

@interface GIFDetailViewController : UIViewController
{
    int m_width;
    int m_height;
    int m_isPlay;
    int m_delay;
    int m_showMenu;
}
@property (weak, nonatomic) IBOutlet UIImageView *m_gifPlayer;
@property (strong, nonatomic) NSString *filePath;

@end

extern NSString*   g_gifPath;
