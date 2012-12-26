//
//  GifLoadViewController.h
//  GIFViewer
//
//  Created by Kimyoung Lee on 12. 10. 27..
//  Copyright (c) 2012년 양원석. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>

@interface GifLoadViewController : UIViewController
    <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    BOOL newMedia;    
}
- (void) useCameraRoll;
@end
