//
//  GridCell.m
//  GIFViewer
//
//  Created by 양원석 on 12. 10. 25..
//  Copyright (c) 2012년 양원석. All rights reserved.
//

#import "GridCell.h"

@implementation GridCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        _label.center = self.center;
        _label.textAlignment = NSTextAlignmentCenter;
        _label.backgroundColor = [UIColor clearColor];
        self.backgroundView = _label;
        self.backgroundColor = [UIColor orangeColor];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    self.backgroundColor = [UIColor orangeColor];
}
*/
@end
