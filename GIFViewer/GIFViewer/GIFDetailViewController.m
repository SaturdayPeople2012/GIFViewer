//
//  GIFDetailViewController.m
//  GIFViewer
//
//  Created by 양원석 on 12. 10. 22..
//  Copyright (c) 2012년 양원석. All rights reserved.
//

#import "GIFDetailViewController.h"

@interface GIFDetailViewController ()

@end

@implementation GIFDetailViewController

@synthesize gifPlayer;

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
        
    NSArray* dirPaths;
    NSString* gifPath;
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    gifPath = [dirPaths objectAtIndex:0];
    gifPath = [gifPath stringByAppendingPathComponent:@"/bear.gif"];
//  gifPath = [gifPath stringByAppendingString:@"/apple_logo_animated.gif"];
    NSLog(@"document path = \"%@\"",gifPath);
    
    ///////////////////////////////////////////////////////////////////////////////////////

#if 1
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"bear" ofType:@"gif"];    
    [manager copyItemAtPath:resourcePath toPath:gifPath error:nil];

#endif
    
    ///////////////////////////////////////////////////////////////////////////////////////
    
    __block CGRect      Outframe;
    __block UIImageView *gifView;
    
    Outframe = self.view.frame;
    
    gifView = [GIF_Library giflib_get_gif_view_from_path:gifPath completion:^(int width,int height)
    {
        CGRect frame;
        frame.origin.x = (Outframe.size.width - width) / 2;
        frame.origin.y = (Outframe.size.height - height) / 2;
        frame.size.width = width;
        frame.size.height = height;

        gifView.frame = frame;
    }];
        
    [gifPlayer addSubview:gifView];
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
        NSLog(@"%@",name);
    }
}

- (void)goFunc:(id)sender
{
    UIImageView* gifAnimation = [[gifPlayer subviews] objectAtIndex:0];
    
//    NSLog(@"--<3>--(%.0f,%.0f)-(%.0f,%.0f)",gifAnimation.frame.origin.x,gifAnimation.frame.origin.y,gifAnimation.frame.size.width,gifAnimation.frame.size.height);
//
//    gifAnimation.frame = CGRectMake(100,100,gifAnimation.frame.size.width+50,gifAnimation.frame.size.height+50);
//
//    [self.m_gifView setAnimationDuration:total/100];

    NSLog(@"animationDuration=%f",gifAnimation.animationDuration);
    
    [gifAnimation setAnimationDuration:gifAnimation.animationDuration + 1];
    
    [gifAnimation startAnimating];
}

- (void)goDelete:(id)sender
{
    UIImageView* gifAnimation = [[gifPlayer subviews] objectAtIndex:0];
    
    [gifAnimation setAnimationDuration:gifAnimation.animationDuration - 1];

    [gifAnimation startAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
