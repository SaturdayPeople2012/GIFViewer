//
//  GIFDetailViewController.m
//  GIFViewer
//
//  Created by CHO,TAE-SANG on 12. 10. 22..
//  Copyright (c) 2012년 CHO,TAE-SANG. All rights reserved.
//

#import "GIFDetailViewController.h"

#import "ELCImagePickerDemoViewController.h"
#import "MessageComposerViewController.h"

#import "SA_OAuthTwitterEngine.h"

#import "ActivityViewCustomProvider.h"
#import "ActivityViewCustomActivity.h"


@interface GIFDetailViewController ()

@end

@implementation GIFDetailViewController

@synthesize m_gifPlayer;

NSString*   g_gifPath = nil;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    UIBarButtonItem *editBtn = [[UIBarButtonItem alloc]initWithTitle:@"편집" style:UIBarButtonItemStyleBordered target:self action:@selector(goEdit:)];
    UIBarButtonItem *editBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(goEdit:)];
    UIBarButtonItem *funcBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(goFunc:)];
    UIBarButtonItem *deleteBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(goDelete:)];
    UIBarButtonItem *slowBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(goPlaySpeed:)];
    UIBarButtonItem *pauseBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(goPausePlay:)];
    UIBarButtonItem *fastBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(goPlaySpeed:)];
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    slowBtn.tag = -1;
    fastBtn.tag =  1;
    
    self.navigationItem.rightBarButtonItem = editBtn;
    self.toolbarItems = [NSArray arrayWithObjects:funcBtn, flexible, slowBtn, flexible, pauseBtn, flexible, fastBtn, flexible, deleteBtn, nil];

    ///////////////////////////////////////////////////////////////////////////////////////
#if 0
    NSArray* dirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    g_gifPath = [dirPath objectAtIndex:0];
//    g_gifPath = [g_gifPath stringByAppendingPathComponent:@"/frozen_pond.gif"];
//    g_gifPath = [g_gifPath stringByAppendingPathComponent:@"/big bear.gif"];
//    g_gifPath = [g_gifPath stringByAppendingPathComponent:@"/color_test.gif"];
//    g_gifPath = [g_gifPath stringByAppendingPathComponent:@"/psy-gangnam-style-1.gif"];
    g_gifPath = [g_gifPath stringByAppendingPathComponent:@"/aa.gif"];
//    g_gifPath = [g_gifPath stringByAppendingPathComponent:@"/kid_and_cat.gif"];
//  g_gifPath = [g_gifPath stringByAppendingString:@"/apple_logo_animated.gif"];
#endif
    NSLog(@"document path = \"%@\"",g_gifPath);
    
    self.title = [g_gifPath lastPathComponent];
    
    ///////////////////////////////////////////////////////////////////////////////////////
                             
//    self.navigationController.view.alpha = 0.5;

    ///////////////////////////////////////////////////////////////////////////////////////
    
    m_width = m_height = m_delay = 0, m_isPlay = 1, m_showMenu = 1;

    ///////////////////////////////////////////////////////////////////////////////////////

    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    CGPoint center;
    NSLog(@"m_gifPlayer frame = %@",NSStringFromCGRect(self.navigationController.view.frame));
    if (orientation == UIInterfaceOrientationLandscapeRight || orientation ==  UIInterfaceOrientationLandscapeLeft)
    {
        center = CGPointMake(self.navigationController.view.frame.size.height/2.0, self.navigationController.view.frame.size.width/2.0);
    } else {
        center = CGPointMake(self.navigationController.view.frame.size.width/2.0, self.navigationController.view.frame.size.height/2.0);
    }
    [spinner setCenter:center]; // I do this because I'm in landscape mode
    [self.navigationController.view addSubview:spinner]; // spinner is not visible until started
    
    [spinner startAnimating];

    ///////////////////////////////////////////////////////////////////////////////////////

    __block UIImageView *gifView;
    
    gifView = [GIF_Library giflib_get_gif_view_from_path:g_gifPath parent:self completion:^(int width,int height)
    {
        m_width = width, m_height = height;
        gifView.frame = [self adjustViewSizeAndLocate:width height:height];

        [spinner stopAnimating];
    }];
    
    gifView.tag = 100;
        
    [m_gifPlayer addSubview:gifView];
    self.view.backgroundColor = [UIColor blackColor];
}

- (CGRect)adjustViewSizeAndLocate:(int)width height:(int)height
{
    CGRect view;
    float   x,t_width,power_x;
    float   y,t_height,power_y,statusBarHeight;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    CGRect fullScreenRect = [[UIScreen mainScreen] bounds]; //implicitly in Portrait orientation.
    CGRect statusBar = [[UIApplication sharedApplication] statusBarFrame];

    NSLog(@"Status Bar Size : %@",NSStringFromCGRect(statusBar));
    
    if (orientation == UIInterfaceOrientationLandscapeRight || orientation ==  UIInterfaceOrientationLandscapeLeft)
    {
        CGRect temp = CGRectZero;
        temp.size.width = fullScreenRect.size.height;
        temp.size.height = fullScreenRect.size.width;
        fullScreenRect = temp;
        
        statusBarHeight = statusBar.size.width;
    } else
    {
        statusBarHeight = statusBar.size.height;
    }
    
    NSLog(@"FullScreenRect : %@",NSStringFromCGRect(fullScreenRect));
    
    if (width > fullScreenRect.size.width || height > fullScreenRect.size.height)
    {
        power_x = width / fullScreenRect.size.width;
        power_y = height / fullScreenRect.size.height;
        if (power_x > power_y)
        {
            x = 0, t_width = fullScreenRect.size.width;
            t_height = height / power_x;
            y = (fullScreenRect.size.height - t_height) / 2;
        } else
        {
            y = 0, t_height = fullScreenRect.size.height;
            t_width = width / power_y;
            x = (fullScreenRect.size.width - t_width) / 2;
        }
    } else
    {
        x = (fullScreenRect.size.width - width) / 2;
        y = (fullScreenRect.size.height - height) / 2;
        t_width = width;
        t_height = height;
    }

//    CGPoint winPoint = [self.view.superview convertPoint:self.view.bounds.origin  toView:nil];
//    NSLog(@"winPoint.x=%f, winPoint.y=%f",winPoint.x, winPoint.y);

    NSLog(@"view.origin.x=%f, view.origin.y=%f",self.view.frame.origin.x,self.view.frame.origin.y);
    
    view.origin.x = x;
    if (m_showMenu) view.origin.y = y - (self.navigationController.navigationBar.frame.size.height + statusBarHeight);
    else            view.origin.y = y;
    view.size.width = t_width;
    view.size.height = t_height;
    
    return view;
}

- (void)goEdit:(id)sender
{
    m_alertType = kAlertType_Edit;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"GIF의 제목을 입력하십시요"
                                                message:@""
                                                delegate:self
                                                cancelButtonTitle:@"취소"
                                                otherButtonTitles:@"확인", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;

    
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex = %d",buttonIndex);
    if (buttonIndex == 1)
    {
        if (m_alertType == kAlertType_Edit)
        {
            NSString *name = [alertView textFieldAtIndex:0].text;
            // name contains the entered value

            self.title = name;
                    
            GIF_Library* inst = [GIF_Library giflib_sharedInstance];
            
            NSMutableData* gif_new = [inst giflib_gif_copy_with_comment:name];
            
            NSLog(@"gif_new length = %d",[gif_new length]);
            
            [gif_new writeToFile:g_gifPath atomically:YES];
        } else
        if (m_alertType == kAlertType_Delete)
        {
             NSFileManager *fileMgr = [NSFileManager defaultManager];
             NSError *error;
             
             if ([fileMgr removeItemAtPath:g_gifPath error:&error] != YES) NSLog(@"Unable to delete file: %@", [error localizedDescription]);
        }
    }
}

- (void)goFunc:(id)sender
{
//    self.title 에 GIFViwer 파일의 제목이 들어있습니다.
    
    
    NSString *textItem =self.title;
    
    textItem = [ textItem  stringByReplacingOccurrencesOfString: @"gif" withString:@""];

    
    //클립보드 복사하기
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.persistent = YES;
    NSString *gifPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"KTH.gif"];
    NSData *gifData = [[NSData alloc] initWithContentsOfFile:gifPath];
    [pasteboard setData:gifData forPasteboardType:@"com.compuserve.gif"];
    
    
    ActivityViewCustomProvider *customProvider = [[ActivityViewCustomProvider alloc]init];
    NSArray *items = [NSArray arrayWithObjects:customProvider,textItem,gifData,nil];
    
    ActivityViewCustomActivity *ca = [[ActivityViewCustomActivity alloc]init];
    
    UIActivityViewController *activityVC =
    [[UIActivityViewController alloc] initWithActivityItems:items
                                      applicationActivities:[NSArray arrayWithObject:ca]];
    
    activityVC.excludedActivityTypes = @[UIActivityTypeMessage ,UIActivityTypePostToWeibo, UIActivityTypeSaveToCameraRoll];
    
    activityVC.completionHandler = ^(NSString *activityType, BOOL completed)
    {
        NSLog(@" activityType: %@", activityType);
        NSLog(@" completed: %i", completed);
    };
    
    [self presentViewController:activityVC animated:YES completion:nil];
    
    
}

- (void)goDelete:(id)sender
{
    // 모달뷰로 "확인" 메세지를 띄웁니다. ////////////////////////////////////
    m_alertType = kAlertType_Delete;

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"삭제 확인" message:@"정말로 파일을 지우시겠습니까?" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"삭제", nil];
    [alert show];
    
    NSRunLoop *rl = [NSRunLoop currentRunLoop];
    NSDate *d;
    while ([alert isVisible])
    {
        d = [[NSDate alloc] init];
        [rl runUntilDate:d];
    }
}

- (void)goPlaySpeed:(UIBarButtonItem*)sender
{
    int tag = sender.tag * -1;
    
    if ((m_delay + tag) < -5 || (m_delay + tag) > 5) return;
    
    m_delay += tag;
    
    NSLog(@"delay = %d",m_delay);
    
    UIImageView* gifAnimation = [[m_gifPlayer subviews] objectAtIndex:0];

    GIF_Library* inst = [GIF_Library giflib_sharedInstance];
        
    NSLog(@"animationDuration=%f",(inst.m_delay_total + ((inst.m_delay_total / 8) * m_delay)) / 100);
    
    [gifAnimation setAnimationDuration:(inst.m_delay_total + ((inst.m_delay_total / 8) * m_delay)) / 100];
    
    [gifAnimation startAnimating];
}

- (void)goPausePlay:(UIBarButtonItem*)sender
{
    UIImageView* gifAnimation = [[m_gifPlayer subviews] objectAtIndex:0];

    if (m_isPlay == 1) [gifAnimation stopAnimating];
    else               [gifAnimation startAnimating];
 
    m_isPlay ^= 1;

    NSMutableArray* btnItems = [self.toolbarItems mutableCopy];

    if (m_isPlay)
    {
        UIBarButtonItem *pauseBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(goPausePlay:)];
        [btnItems replaceObjectAtIndex:4 withObject:pauseBtn];
    } else
    {
        UIBarButtonItem *playBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(goPausePlay:)];
        [btnItems replaceObjectAtIndex:4 withObject:playBtn];
    }
    
    self.toolbarItems = btnItems;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
//    NSLog(@"willAnimateRotationToInterfaceOrientation");

    [m_gifPlayer viewWithTag:100].frame = [self adjustViewSizeAndLocate:m_width height:m_height];
}

-(void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    [super touchesEnded:touches withEvent:event];
    
    m_gifPlayer.center = self.view.center;
    
    m_showMenu ^= 1;

    if (m_showMenu)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        [self.navigationController setToolbarHidden:NO];
    } else
    {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        [self.navigationController setToolbarHidden:YES];
    }
    
    [m_gifPlayer viewWithTag:100].frame = [self adjustViewSizeAndLocate:m_width height:m_height];
}

@end
