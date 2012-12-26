//
//  ActivityViewCustomProvider.m
//  GIFViewer
//
//  Created by Beatrice Dalle on 11/18/12.
//  Copyright (c) 2012 양원석. All rights reserved.
//

#import "ActivityViewCustomProvider.h"

@implementation ActivityViewCustomProvider

#pragma mark - UIActivityItemSource

- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType
{
    NSLog(@"Function Name  : %s",__FUNCTION__);
    NSLog(@"ActivityType : %@", activityType);
    return [super activityViewController:activityViewController itemForActivityType:activityType];
}


@end
