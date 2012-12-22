//
//  ListCell.h
//  GIFViewer
//
//  Created by Cruz on 12. 10. 23..
//  Copyright (c) 2012년 양원석. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListCell : UITableViewCell 

@property (weak,nonatomic) IBOutlet UIImageView *gifImage;
@property (weak,nonatomic) IBOutlet UILabel *title;
@property (weak,nonatomic) IBOutlet UILabel *time;
@property (weak,nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) UIButton *button;
@end
