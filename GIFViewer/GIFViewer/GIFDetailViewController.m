//
//  GIFDetailViewController.m
//  GIFViewer
//
//  Created by CHO,TAE-SANG on 12. 10. 22..
//  Copyright (c) 2012년 CHO,TAE-SANG. All rights reserved.
//

#import "GIFDetailViewController.h"

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
    
    self.title = @"GIFViewer";

    NSRange range = [g_gifPath rangeOfString:@"/" options:NSBackwardsSearch];
    if (range.location != NSNotFound)
    {
        NSRange rangeToFileName = NSMakeRange(range.location+1,[g_gifPath length] - 1); // get a range without the space character
        NSLog(@"Range = %@",NSStringFromRange(rangeToFileName));
//        NSString *strTitle = [g_gifPath substringWithRange:rangeToFileName];
//        NSLog(@"Found ain at %@",strTitle);
    }
    // prints "Found ain at 40"
    ///////////////////////////////////////////////////////////////////////////////////////
                             
//    self.navigationController.view.alpha = 0.5;

    ///////////////////////////////////////////////////////////////////////////////////////
    
    m_width = m_height = m_delay = 0, m_isPlay = 1, m_showMenu = 1;
    
    __block UIImageView *gifView;
    
    gifView = [GIF_Library giflib_get_gif_view_from_path:g_gifPath parent:self completion:^(int width,int height)
    {
        m_width = width, m_height = height;
        gifView.frame = [self adjustViewSizeAndLocate:width height:height];
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
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"GIF의 제목을 입력하십시요"
                                                message:@""
                                                delegate:self
                                                cancelButtonTitle:@"확인"
                                                otherButtonTitles:@"취소", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;

    
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
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

- (void)goFunc:(id)sender
{
}

- (void)goDelete:(id)sender
{
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
