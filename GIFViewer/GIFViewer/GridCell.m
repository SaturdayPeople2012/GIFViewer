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
        //나중에 썸네일이 어레이로 넘어올경우에는 GridViewController에서 작업하면됨.. 여기는 DefaultImage로 바꾸고..
        //document 경로
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *documentsDirectory = [paths objectAtIndex:0];
        self.gifImgView = [[UIImageView alloc]init];//WithImage:[UIImage imageNamed:@"bear.gif"]];
        _gifImgView.center = self.center;
        self.backgroundView = _gifImgView;
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button.frame = CGRectMake(0, 0, 65, 65);//self.frame;

        [self addSubview:_button];

        
        
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
