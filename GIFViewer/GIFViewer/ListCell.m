//
//  ListCell.m
//  GIFViewer
//
//  Created by Cruz on 12. 10. 23..
//  Copyright (c) 2012년 양원석. All rights reserved.
//

#import "ListCell.h"

@implementation ListCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //<my stuff>
    NSLog(@"swipe\n");
    
    NSDictionary *notiDic = [NSDictionary dictionaryWithObject:self.title.text forKey:@"inputText"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cellInfo"
                                                        object:nil userInfo:notiDic];
    [super touchesMoved:touches withEvent:event];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
