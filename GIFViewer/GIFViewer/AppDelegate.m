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
//    [UIView Start];
    self.naviController = [[UINavigationController alloc]init];
//    self.segmentedContol
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    MainViewController *mainVC = [[MainViewController alloc]initWithNibName:@"MainViewController" bundle:nil];
    [self.naviController pushViewController:mainVC animated:NO];
    [self.naviController setToolbarHidden:NO];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    self.naviController.navigationBar.tintColor = [UIColor blackColor];
    self.naviController.toolbar.tintColor = [UIColor blackColor];
    
    self.window.rootViewController = self.naviController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (NSArray *)segmentViewControllers{
    UIViewController *gridViewContorller =[[GridViewController alloc]initWithNibName:@"GridViewController" bundle:nil];
    UIViewController *listViewController = [[ListViewController alloc]init];
    
    NSArray *viewContollers = @[gridViewContorller,listViewController];
    return viewContollers;
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
