//
//  SegmentsController.h
//  GIFViewer
//
//  Created by 양원석 on 12. 12. 8..
//  Copyright (c) 2012년 양원석. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SegmentsController : NSObject

@property (strong, nonatomic, readonly) NSArray *viewControllers;

@property (strong, nonatomic, readonly) UINavigationController *navigationController;

- (id)initWithNavigationController:(UINavigationController *)aNavigationController
                   viewControllers:(NSArray *)viewControllers;

- (void)indexDidChangeForSegmentedControl:(UISegmentedControl *)aSegmentedControl;

@end
