//
//  GridCell.h
//  GIFViewer
//
//  Created by 양원석 on 12. 10. 25..
//  Copyright (c) 2012년 양원석. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GridCell : UICollectionViewCell
//임시 레이블
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;
@end
