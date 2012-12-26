//
//  GIFDetailViewController.h
//  GIFViewer
//
//  Created by CHO,TAE-SANG on 12. 10. 22..
//  Copyright (c) 2012년 CHO,TAE-SANG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GIF_Library.h"
#import <Social/Social.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <Accounts/Accounts.h>
#import "MessageComposerViewController.h"
#import "GSTwitPicEngine.h"

#import "SA_OAuthTwitterController.h"

#define kAlertType_Edit     1
#define kAlertType_Delete   2

@interface GIFDetailViewController : UIViewController <UIAlertViewDelegate,GSTwitPicEngineDelegate>
{
    int m_width;
    int m_height;
    int m_isPlay;
    int m_delay;
    int m_showMenu;
    int m_alertType;
}
@property (weak, nonatomic) IBOutlet UIImageView *m_gifPlayer;

@end

extern NSString*    g_gifPath;
