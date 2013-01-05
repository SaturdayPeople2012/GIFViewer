//
//  AppDelegate.m
//  GIFViewer
//
//  Created by 양원석 on 12. 10. 21..
//  Copyright (c) 2012년 양원석. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "GridViewController.h"
#import "ListViewController.h"
#define kGridMode 0
#define kListMode 1
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor blackColor];
    
    self.naviController = [[UINavigationController alloc]init];
    MainViewController *mainVC = [[MainViewController alloc]initWithNibName:@"MainViewController" bundle:nil];
    [self.naviController pushViewController:mainVC animated:NO];
    [self.naviController setToolbarHidden:NO];

#if 0
    NSArray* dirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    g_gifPath = [dirPath objectAtIndex:0];
    NSLog(@"document path = \"%@\"",g_gifPath);
#endif

    //////////////////////////////////////////////////////
    UIBarButtonItem *loadBtn = [[UIBarButtonItem alloc]initWithTitle:@"Load" style:UIBarButtonItemStyleBordered
                                                              target:self action:@selector(goLoad:)];
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                                 UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"Grid",@"List"]];
    segmentedControl.selectedSegmentIndex=0;
    segmentedControl.frame = CGRectMake(0, 0, 130, 30);
    [segmentedControl addTarget:self action:@selector(selectedMode:) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *segBtn = [[UIBarButtonItem alloc]initWithCustomView:segmentedControl];

    self.naviController.toolbar.items = [NSArray arrayWithObjects:flexible, segBtn,flexible, loadBtn, nil];
    /////////////////////////////////////////////////////

    
    self.window.rootViewController = self.naviController;
    [self.window makeKeyAndVisible];
    return YES;
}
- (void) selectedMode:(UISegmentedControl *)sender{
    UISegmentedControl *control = sender;
    //TODO: 추후 AppDelegate로 뺄것!
    GridViewController *gridVC = [[GridViewController alloc]initWithNibName:@"GridViewController" bundle:nil];
    ListViewController *listVC = [[ListViewController alloc]initWithNibName:@"ListViewController" bundle:nil];
    switch (control.selectedSegmentIndex) {
        case kGridMode:
            [self.window.rootViewController.view addSubview:gridVC.view];
            break;
        case kListMode:
            [self.window.rootViewController.view addSubview:listVC.view];
            break;
        default:
            break;
    }
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
