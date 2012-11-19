//
//  GIFDetailViewController.h
//  GIFViewer
//
//  Created by 양원석 on 12. 10. 22..
//  Copyright (c) 2012년 양원석. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GIF_Library.h"

@interface GIFDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *m_gifPlayer;

@end

extern NSString*   g_gifPath;
