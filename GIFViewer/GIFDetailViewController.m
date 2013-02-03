//
//  GIFDetailViewController.m
//  GIFViewer
//
//  Created by CHO,TAE-SANG on 12. 10. 22..
//  Copyright (c) 2012년 CHO,TAE-SANG. All rights reserved.
//

#import "GIFDetailViewController.h"

#import "ELCImagePickerDemoViewController.h"

#import "SA_OAuthTwitterEngine.h"

#import "ActivityViewCustomProvider.h"
#import "ActivityViewCustomActivity.h"


@interface GIFDetailViewController ()

@end

@implementation GIFDetailViewController

@synthesize m_gifPlayer;
@synthesize m_speedGuide;
@synthesize m_timer;

NSString*   g_gifPath = nil;

//                  0    1    2    3    4    5    6    7    8    9
float delay_t[] = { 0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 1.3, 1.5, 1.7, 2.0 };

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
    //UIImageView* gifAnimation = [[m_gifPlayer subviews] objectAtIndex:0];
    
    
    // Do any additional setup after loading the view from its nib.
    
    //    UIBarButtonItem *editBtn = [[UIBarButtonItem alloc]initWithTitle:@"편집" style:UIBarButtonItemStyleBordered target:self action:@selector(goEdit:)];
    
    UIBarButtonItem *editBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(goEdit:)];
    UIBarButtonItem *funcBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(goFunc:)];
    UIBarButtonItem *deleteBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(goDelete:)];
#if 0
    UIBarButtonItem *slowBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(goPlaySpeed:)];
    UIBarButtonItem *pauseBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(goPausePlay:)];
    UIBarButtonItem *fastBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(goPlaySpeed:)];
#else
    UIBarButtonItem *slowBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backward.png"] style:UIBarButtonItemStylePlain target:self action:@selector(goPlaySpeed:)];
    UIBarButtonItem *pauseBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"stop.png"] style:UIBarButtonItemStylePlain target:self action:@selector(goPausePlay:)];
    UIBarButtonItem *fastBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"forward.png"] style:UIBarButtonItemStylePlain target:self action:@selector(goPlaySpeed:)];
#endif
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
    
//    self.title = [g_gifPath lastPathComponent];
    
    ///////////////////////////////////////////////////////////////////////////////////////
    
    //    self.navigationController.view.alpha = 0.5;
    
    ///////////////////////////////////////////////////////////////////////////////////////
    
    m_width = m_height = 0, m_isPlay = 1, m_showMenu = 1;
    m_delay = 5;
    
    ///////////////////////////////////////////////////////////////////////////////////////
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    CGPoint center;
    NSLog(@"self.navigationController.view.frame frame = %@",NSStringFromCGRect(self.navigationController.view.frame));
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

                   if (self.title == nil) self.title = [g_gifPath lastPathComponent];
                   
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
    GIF_Library* inst = [GIF_Library giflib_sharedInstance];
    
    NSLog(@"animationDuration=%f",(inst.m_delay_total / delay_t[m_delay]) / 100);
//    [self.num initWithFormat:@"%f",inst.m_delay_total/100];
    return view;
}

- (void)goEdit:(id)sender
{
    m_alertType = kAlertType_Edit;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"GIF의 제목을 입력하십시요"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"OK", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [alertView textFieldAtIndex:0].text = self.title;
    
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
        }
    }
}

- (void)goFunc:(id)sender
{
    
    NSString *textItem =self.title;
    textItem = [ textItem  stringByReplacingOccurrencesOfString: @".gif" withString:@""];
    
    NSString *string1 = @"/";
    NSString *string2 = @"";
    textItem = [string1 stringByAppendingString:textItem];
    textItem = [textItem stringByAppendingString:string2];
    
    
    NSArray *sysPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *docDirectory = [sysPaths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@%@",docDirectory, textItem];
    
    
    //클립보드 복사하기
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.persistent = YES;
    //NSString *gifPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:filePath];
    NSData *gifData = [[NSData alloc] initWithContentsOfFile:filePath];
    [pasteboard setData:gifData forPasteboardType:@"com.compuserve.gif"];
    
    //  NSLog(@"gifPath : %@",gifPath);
    NSLog(@"docDirectory : %@",docDirectory);
    NSLog(@"filePath : %@",filePath);

    
    ActivityViewCustomProvider *customProvider = [[ActivityViewCustomProvider alloc]init];
    NSArray *items = [NSArray arrayWithObjects:customProvider,textItem,gifData,nil];
    
    ActivityViewCustomActivity *ca = [[ActivityViewCustomActivity alloc]init];
    
    UIActivityViewController *activityVC =
    [[UIActivityViewController alloc] initWithActivityItems:items
                                      applicationActivities:[NSArray arrayWithObject:ca]];
    
    activityVC.excludedActivityTypes = @[UIActivityTypeMessage ,UIActivityTypePostToWeibo, UIActivityTypeSaveToCameraRoll,UIActivityTypeAssignToContact,UIActivityTypePrint,UIActivityTypeCopyToPasteboard];
    
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
/*
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
 */
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"Delete File" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"OK" otherButtonTitles:nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    
    self.navigationController.toolbarHidden = YES;
//    [actionSheet showFromToolbar:(UIToolbar*)self.view];
    [actionSheet showInView: self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	// the user clicked one of the OK/Cancel buttons
    
    self.navigationController.toolbarHidden = NO;
    
	if (buttonIndex == 0)
	{
		NSLog(@"ok");

        NSFileManager *fileMgr = [NSFileManager defaultManager];
        NSError *error;
        
        if ([fileMgr removeItemAtPath:g_gifPath error:&error] != YES) NSLog(@"Unable to delete file: %@", [error localizedDescription]);
	} else
	{
		NSLog(@"cancel");
	}
}

- (void)timerTicked:(NSTimer*)timer
{
    m_tickDown --;

    m_speedGuide.alpha -= 0.2;
    
    if (m_tickDown < 0)
    {
        [m_timer invalidate];
        m_timer = nil;

        if (m_speedGuide)
        {
            [m_speedGuide removeFromSuperview];
            m_speedGuide = nil;
        }
    }
}

- (void)showSpeedGuide:(int)show
{
    if (m_speedGuide)
    {
        [m_speedGuide removeFromSuperview];
        m_speedGuide = nil;
    }
    
    if (show)
    {
        CGRect rect;
        
        rect.origin.x = (m_gifPlayer.frame.size.width / 2) - 20;
        rect.origin.y = (m_gifPlayer.frame.size.height) - 25;
        rect.size.width = 40;
        rect.size.height = 20;
        
        NSLog(@"rect : %@",NSStringFromCGRect(rect));
        
        m_speedGuide = [[UITextField alloc] initWithFrame:rect];
        m_speedGuide.borderStyle = UITextBorderStyleNone;
        m_speedGuide.textAlignment = NSTextAlignmentRight;
        m_speedGuide.textColor = [UIColor whiteColor];
        m_speedGuide.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        m_speedGuide.alpha = 1.0;
        
        [m_gifPlayer addSubview:m_speedGuide];
        
        m_speedGuide.text = [NSString stringWithFormat:@"%.1fx",delay_t[m_delay]];
        
        if (m_timer)
        {
            [m_timer invalidate];
            m_timer = nil;
        }

        m_tickDown = 5;
        m_timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerTicked:) userInfo:nil repeats:YES];
    }
}

- (void)goPlaySpeed:(UIBarButtonItem*)sender
{
    int tag = sender.tag;
    
    if ((m_delay + tag) < 0 || (m_delay + tag) >= (sizeof(delay_t)/sizeof(delay_t[0])))
    {
        [self showSpeedGuide:true];
        return;
    }
    
    m_delay += tag;
    
    NSLog(@"delay = %d",m_delay);
    
    UIImageView* gifAnimation = [[m_gifPlayer subviews] objectAtIndex:0];
    
    GIF_Library* inst = [GIF_Library giflib_sharedInstance];
    
    NSLog(@"animationDuration=%f",(inst.m_delay_total / delay_t[m_delay]) / 100);
    [gifAnimation setAnimationDuration:(inst.m_delay_total / delay_t[m_delay]) / 100];
    
    [gifAnimation startAnimating];
    
    if (m_isPlay == 0)
    {
        m_isPlay = 1;

        NSMutableArray* btnItems = [self.toolbarItems mutableCopy];
        
//        UIBarButtonItem *pauseBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(goPausePlay:)];
        UIBarButtonItem *pauseBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"stop.png"] style:UIBarButtonItemStylePlain target:self action:@selector(goPausePlay:)];
        [btnItems replaceObjectAtIndex:4 withObject:pauseBtn];

        self.toolbarItems = btnItems;
    }
    
    [self showSpeedGuide:true];
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
//        UIBarButtonItem *pauseBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(goPausePlay:)];
        UIBarButtonItem *pauseBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"stop.png"] style:UIBarButtonItemStylePlain target:self action:@selector(goPausePlay:)];
        [btnItems replaceObjectAtIndex:4 withObject:pauseBtn];
    } else
    {
//        UIBarButtonItem *playBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(goPausePlay:)];
        UIBarButtonItem *playBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"play.png"] style:UIBarButtonItemStylePlain target:self action:@selector(goPausePlay:)];
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

    if (m_timer)
    {
        [m_timer invalidate];
        m_timer = nil;
    }
    if (m_speedGuide)
    {
        [m_speedGuide removeFromSuperview];
        m_speedGuide = nil;
    }
    
    [m_gifPlayer viewWithTag:100].frame = [self adjustViewSizeAndLocate:m_width height:m_height];
}

-(void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    [super touchesEnded:touches withEvent:event];

    if (m_timer)
    {
        [m_timer invalidate];
        m_timer = nil;
    }
    if (m_speedGuide)
    {
        [m_speedGuide removeFromSuperview];
        m_speedGuide = nil;
    }
    
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
