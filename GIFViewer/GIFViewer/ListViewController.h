//
//  ListViewController.h
//  GIFViewer
//
//  Created by 양원석 on 12. 10. 22..
//  Copyright (c) 2012년 양원석. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListCell.h"
@interface ListViewController : UITableViewController <UIActionSheetDelegate>{
    /*
     UIBarButtonItem *editButton;
     UIBarButtonItem *deleteButton;
     UIBarButtonItem *closeButton;
     */
    UIBarButtonItem *loadButton;
    UIBarButtonItem *flexible;
    
    UIBarButtonItem *editButton;
    UIBarButtonItem *cancelButton;
    UIBarButtonItem *deleteButton;
    
}

@property (strong,nonatomic) NSMutableArray *listData;
@property (nonatomic, strong) UIBarButtonItem *editButton;
@property (nonatomic, strong) UIBarButtonItem *cancelButton;
@property (nonatomic, strong) UIBarButtonItem *deleteButton;


@end
