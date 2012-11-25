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

@property (weak, nonatomic) IBOutlet UIImageView *m_gifPlayer;

@end

extern NSString*   g_gifPath;
