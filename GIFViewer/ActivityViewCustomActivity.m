//
//  ActivityViewCustomActivity.m
//  GIFViewer
//
//  Created by Beatrice Dalle on 11/18/12.
//  Copyright (c) 2012 양원석. All rights reserved.
//

#import "ActivityViewCustomActivity.h"

@implementation ActivityViewCustomActivity


- (NSString *)activityType
{
    return @"GifViewer.App";
}

- (NSString *)activityTitle
{
    return @"메시지 공유하기(문자창에서 복사하기 누르세요)";
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    NSLog(@"%s", __FUNCTION__);
    return YES;
}

- (UIImage *)activityImage
{
    // Note: These images need to have a transparent background and I recommend these sizes:
    // iPadShare@2x should be 126 px, iPadShare should be 53 px, iPhoneShare@2x should be 100
    // px, and iPhoneShare should be 50 px. I found these sizes to work for what I was making.
    //This is what mine looked like: Here is the .PSD I made: http://www.filedropper.com/ios6share And here is the original 250 px .png http://i.imgur.com/jaK0Z.png
    
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return [UIImage imageNamed:@"Icon.png"];
    }
    
    return [UIImage imageNamed:@"iOS6Share8.png"];
}


- (void)prepareWithActivityItems:(NSArray *)activityItems
{
    NSLog(@"%s",__FUNCTION__);
}

- (UIViewController *)activityViewController
{
    NSLog(@"%s",__FUNCTION__);
    return nil;
}

- (void)performActivity
{
    // This is where you can do anything you want, and is the whole reason for creating a custom
    // UIActivity and UIActivityProvider
    
    // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=yourappid"]];
    
    /*
     UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
     pasteboard.persistent = YES;
     NSString *gifPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"KTH.gif"];
     NSData *gifData = [[NSData alloc] initWithContentsOfFile:gifPath];
     [pasteboard setData:gifData forPasteboardType:@"com.compuserve.gif"];
     */
    
    NSString *phoneToCall = @"sms:010-2597-4571";
    NSString *phoneToCallEncoded = [phoneToCall stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSURL *url = [[NSURL alloc] initWithString:phoneToCallEncoded];
    
    
    [[UIApplication sharedApplication] openURL:url];
    
    
    [self activityDidFinish:YES];
}
@end
