//
//  SegmentsController.m
//  GIFViewer
//
//  Created by 양원석 on 12. 12. 8..
//  Copyright (c) 2012년 양원석. All rights reserved.
//

#import "SegmentsController.h"
@interface SegmentsController ()
@property (nonatomic, retain, readwrite) NSArray                * viewControllers;
@property (nonatomic, retain, readwrite) UINavigationController * navigationController;
@end

@implementation SegmentsController

-(id)initWithNavigationController:(UINavigationController *)aNavigationController viewControllers:(NSArray *)viewControllers{
    self = [super init];
    if (self) {
        self.navigationController = aNavigationController;
        self.viewControllers = viewControllers;
    }
    return self;}

-(void)indexDidChangeForSegmentedControl:(UISegmentedControl *)aSegmentedControl{
    NSUInteger index = aSegmentedControl.selectedSegmentIndex;
    UIViewController *incomingViewContoller = self.viewControllers[index];
    NSArray *theViewControllers = @[incomingViewContoller];
    [self.navigationController setViewControllers:theViewControllers animated:NO];
    
    incomingViewContoller.navigationController.toolbarItems;
}


@end
