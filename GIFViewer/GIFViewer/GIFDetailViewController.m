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

-(CGRect)getScreenBoundsForOrientation:(UIInterfaceOrientation)orientation
{
    
    UIScreen *screen = [UIScreen mainScreen];
    CGRect fullScreenRect = screen.bounds; //implicitly in Portrait orientation.
    
    if (orientation == UIInterfaceOrientationLandscapeRight || orientation ==  UIInterfaceOrientationLandscapeLeft)
    {
        CGRect temp = CGRectZero;
        temp.size.width = fullScreenRect.size.height;
        temp.size.height = fullScreenRect.size.width;
        fullScreenRect = temp;
    }
    
    return fullScreenRect;
}

-(CGRect)getScreenBoundsForCurrentOrientation
{
    return [self getScreenBoundsForOrientation:[UIApplication sharedApplication].statusBarOrientation];
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
    
    g_gifPath = _filePath;
    ///////////////////////////////////////////////////////////////////////////////////////
    
    m_width = m_height = m_delay = 0, m_isPlay = 1, m_showMenu = 1;
    
    __block UIImageView *gifView;
    
    gifView = [GIF_Library giflib_get_gif_view_from_path:g_gifPath parent:self completion:^(int width,int height)
               {
                   //        __block CGRect      rcFrame = self.view.frame;
                   __block CGRect      rcFrame = [self getScreenBoundsForCurrentOrientation];
                   
                   NSLog(@"(%f,%f)-(%f,%f)",rcFrame.origin.x,rcFrame.origin.y,rcFrame.size.width,rcFrame.size.height);
                   
                   m_width = width, m_height = height;
                   gifView.frame = [self adjustViewSizeAndLocate:rcFrame width:width height:height];
               }];
    
    gifView.tag = 100;
    
    [m_gifPlayer addSubview:gifView];
    self.view.backgroundColor = [UIColor blackColor];
    
    ///태상이형 미안 ㅋㅋ
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightView:)];
    swipeGesture.numberOfTouchesRequired =1;
    [swipeGesture setDirection:UISwipeGestureRecognizerDirectionLeft];
    
    [self.view addGestureRecognizer:swipeGesture];
    
    UISwipeGestureRecognizer *swipeGesture2 = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftView:)];
    swipeGesture.numberOfTouchesRequired =1;
    [swipeGesture2 setDirection:UISwipeGestureRecognizerDirectionRight];
    
    [self.view addGestureRecognizer:swipeGesture2];
    


}

-(void)rightView:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"right");
}

-(void)leftView:(UIGestureRecognizer *)gestureRecognizer{
    NSLog(@"left");
}

- (void)toggleBar{
    m_gifPlayer.center = self.view.center;
    
    m_showMenu ^= 1;
    
    if (m_showMenu)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        [[self navigationController] setNavigationBarHidden:NO animated:NO];
        [self.navigationController setToolbarHidden:NO];
    } else
    {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        [[self navigationController] setNavigationBarHidden:YES animated:NO];
        [self.navigationController setToolbarHidden:YES];
    }
    
    //    CGRect rc = self.view.frame;
    CGRect rc = [self getScreenBoundsForCurrentOrientation];
    
    if (m_showMenu) rc.size.height -= (20 + 44 + 50);
    
    [m_gifPlayer viewWithTag:100].frame = [self adjustViewSizeAndLocate:rc width:m_width height:m_height];
}
- (void)changeView:(UISwipeGestureRecognizer *)gesture{
    if (gesture.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"go left");
    }else if(gesture.direction == UISwipeGestureRecognizerDirectionLeft){
        NSLog(@"go right");
    }
}


///////////////////////////////////
- (CGRect)adjustViewSizeAndLocate:(CGRect)screen width:(int)width height:(int)height
{
    CGRect view;
    float   x,t_width,power_x;
    float   y,t_height,power_y;
    
    NSLog(@"(1)width=%d, screen.size.width=%f, height=%d, screen.size.height=%f",width,screen.size.width,height,screen.size.height);
    if (width > screen.size.width || height > screen.size.height)
    {
        NSLog(@"(2)width=%d, screen.size.width=%f, height=%d, screen.size.height=%f",width,screen.size.width,height,screen.size.height);
        power_x = width / screen.size.width;
        power_y = height / screen.size.height;
        if (power_x > power_y)
        {
            x = 0, t_width = screen.size.width;
            t_height = height / power_x;
            y = (screen.size.height - t_height) / 2;
        } else
        {
            y = 0, t_height = screen.size.height;
            t_width = width / power_y;
            x = (screen.size.width - t_width) / 2;
        }
    } else
    {
        x = (screen.size.width - width) / 2;
        y = (screen.size.height - height) / 2;
        t_width = width;
        t_height = height;
    }
    
    //    CGPoint winPoint = [self.view.superview convertPoint:self.view.bounds.origin  toView:nil];
    //    NSLog(@"winPoint.x=%f, winPoint.y=%f",winPoint.x, winPoint.y);
    
    NSLog(@"view.origin.x=%f, view.origin.y=%f",self.view.frame.origin.x,self.view.frame.origin.y);
    
    view.origin.x = x;
    view.origin.y = y;
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
    
    //    CGRect rc = self.view.frame;
    CGRect rc = [self getScreenBoundsForCurrentOrientation];
    
    NSLog(@"(%f,%f)-(%f,%f)",rc.origin.x,rc.origin.y,rc.size.width,rc.size.height);
    
    [m_gifPlayer viewWithTag:100].frame = [self adjustViewSizeAndLocate:rc width:m_width height:m_height];
}
/*
-(void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    [super touchesEnded:touches withEvent:event];
    m_gifPlayer.center = self.view.center;
    
    m_showMenu ^= 1;
    
    if (m_showMenu)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        [[self navigationController] setNavigationBarHidden:NO animated:NO];
        [self.navigationController setToolbarHidden:NO];
    } else
    {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        [[self navigationController] setNavigationBarHidden:YES animated:NO];
        [self.navigationController setToolbarHidden:YES];
    }
    
    //    CGRect rc = self.view.frame;
    CGRect rc = [self getScreenBoundsForCurrentOrientation];
    
    if (m_showMenu) rc.size.height -= (20 + 44 + 50);
    
    [m_gifPlayer viewWithTag:100].frame = [self adjustViewSizeAndLocate:rc width:m_width height:m_height];
}
*/


@end
