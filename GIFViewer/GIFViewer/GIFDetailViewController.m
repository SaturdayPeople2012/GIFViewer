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
    
    UIBarButtonItem *editBtn = [[UIBarButtonItem alloc]initWithTitle:@"편집" style:UIBarButtonItemStyleBordered
                                                              target:self action:@selector(goEdit:)];
    UIBarButtonItem *funcBtn = [[UIBarButtonItem alloc]initWithTitle:@"기능" style:UIBarButtonItemStyleBordered
                                                              target:self action:@selector(goFunc:)];
    UIBarButtonItem *deleteBtn = [[UIBarButtonItem alloc]initWithTitle:@"삭제" style:UIBarButtonItemStyleBordered
                                                              target:self action:@selector(goDelete:)];
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                                 UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    self.navigationItem.rightBarButtonItem = editBtn;
    self.toolbarItems = [NSArray arrayWithObjects:funcBtn, flexible, deleteBtn, nil];

    ///////////////////////////////////////////////////////////////////////////////////////
#if 1
    NSArray* dirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    g_gifPath = [dirPath objectAtIndex:0];
//    g_gifPath = [g_gifPath stringByAppendingPathComponent:@"/frozen_pond.gif"];
//    g_gifPath = [g_gifPath stringByAppendingPathComponent:@"/big bear.gif"];
    g_gifPath = [g_gifPath stringByAppendingPathComponent:@"/color test.gif"];
//    g_gifPath = [g_gifPath stringByAppendingPathComponent:@"/cat.gif"];
//    g_gifPath = [g_gifPath stringByAppendingPathComponent:@"/kid_and_cat.gif"];
//  g_gifPath = [g_gifPath stringByAppendingString:@"/apple_logo_animated.gif"];
#endif
    NSLog(@"document path = \"%@\"",g_gifPath);
    
    g_gifPath = _filePath;
    ///////////////////////////////////////////////////////////////////////////////////////

#if 0
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"bear" ofType:@"gif"];    
    [manager copyItemAtPath:resourcePath toPath:g_gifPath error:nil];

#endif
    
    ///////////////////////////////////////////////////////////////////////////////////////
    
    m_width = m_height = 0;
    
    __block CGRect      rcFrame;
    __block UIImageView *gifView;
    
    rcFrame = self.view.frame;

    NSLog(@"(%f,%f)-(%f,%f)",rcFrame.origin.x,rcFrame.origin.y,rcFrame.size.width,rcFrame.size.height);
    
    gifView = [GIF_Library giflib_get_gif_view_from_path:g_gifPath parent:self completion:^(int width,int height)
    {
        m_width = width, m_height = height;
        gifView.frame = [self adjustViewSize:rcFrame width:width height:height];
    }];
    
    gifView.tag = 100;
        
    [m_gifPlayer addSubview:gifView];
}

- (CGRect)adjustViewSize:(CGRect)screen width:(int)width height:(int)height
{
    CGRect view;
    float   x,t_width,power_x;
    float   y,t_height,power_y;
    
    if (width > screen.size.width || height > screen.size.height)
    {
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
    UIImageView* gifAnimation = [[m_gifPlayer subviews] objectAtIndex:0];
    
//    NSLog(@"--<3>--(%.0f,%.0f)-(%.0f,%.0f)",gifAnimation.frame.origin.x,gifAnimation.frame.origin.y,gifAnimation.frame.size.width,gifAnimation.frame.size.height);
//
//    gifAnimation.frame = CGRectMake(100,100,gifAnimation.frame.size.width+50,gifAnimation.frame.size.height+50);
//
//    [self.m_gifView setAnimationDuration:total/100];

    NSLog(@"animationDuration=%f",gifAnimation.animationDuration + 1);
    
    [gifAnimation setAnimationDuration:gifAnimation.animationDuration + 1];
    
    [gifAnimation startAnimating];
}

- (void)goDelete:(id)sender
{
    UIImageView* gifAnimation = [[m_gifPlayer subviews] objectAtIndex:0];

    NSLog(@"animationDuration=%f",gifAnimation.animationDuration - 1);
    
    [gifAnimation setAnimationDuration:gifAnimation.animationDuration - 1];

    [gifAnimation startAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
//    NSLog(@"willAnimateRotationToInterfaceOrientation");

    CGRect rc = self.view.frame;  

    [m_gifPlayer viewWithTag:100].frame = [self adjustViewSize:rc width:m_width height:m_height];

//    NSLog(@"(%f,%f)-(%f,%f)",rc.origin.x,rc.origin.y,rc.size.width,rc.size.height);
    
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
        toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        
    }
}

@end
