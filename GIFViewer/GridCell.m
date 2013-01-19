//
//  GridCell.m
//  GIFViewer
//
//  Created by 양원석 on 12. 10. 25..
//  Copyright (c) 2012년 양원석. All rights reserved.
//

#import "GridCell.h"
#import <QuartzCore/QuartzCore.h>
@implementation GridCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        UIView *bgView = [[UIView alloc] initWithFrame:self.backgroundView.frame];
        bgView.backgroundColor = [UIColor blueColor];
        self.selectedBackgroundView = bgView;

        
        self.gifImgView = [[UIImageView alloc]init];
//        self.selectedView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Check-icon.png"]];
        _gifImgView.center = self.center;
//        self.backgroundView = _gifImgView;
//        self.contentView.frame = CGRectMake(3, 3, 59, 59);
        self.gifImgView.frame = CGRectMake(3, 3, 59, 59);
        [self addSubview:_gifImgView];
//        [self.contentView addSubview:_gifImgView];

        self.backgroundColor = [UIColor clearColor];

//        self.selectedView.hidden = YES;
//        [self addSubview:_selectedView];
        
        
        //document 경로
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *documentsDirectory = [paths objectAtIndex:0];
//        
        
//        self.tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped:)];
//        [self addGestureRecognizer:_tapGesture];
 
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
