//
//  ListViewController.h
//  GIFViewer
//
//  Created by 양원석 on 12. 10. 22..
//  Copyright (c) 2012년 양원석. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListCell.h"
#import "GridViewController.h"
@interface ListViewController : UITableViewController <UIActionSheetDelegate>{
<<<<<<< HEAD
  /*
    UIBarButtonItem *editButton;
    UIBarButtonItem *deleteButton;
    UIBarButtonItem *closeButton;
    */
=======
    /*
     UIBarButtonItem *editButton;
     UIBarButtonItem *deleteButton;
     UIBarButtonItem *closeButton;
     */
>>>>>>> 6f60c5d6a780eed729db39d18f7847c3af93f697
    UIBarButtonItem *loadButton;
    UIBarButtonItem *flexible;
    
    UIBarButtonItem *editButton;
    UIBarButtonItem *cancelButton;
    UIBarButtonItem *deleteButton;
    UIBarButtonItem *segBtn;
}

@property (strong,nonatomic) NSMutableArray *listData;
@property (nonatomic, strong) UIBarButtonItem *editButton;
@property (nonatomic, strong) UIBarButtonItem *cancelButton;
@property (nonatomic, strong) UIBarButtonItem *deleteButton;
<<<<<<< HEAD
@property (strong, nonatomic) NSMutableArray *gifDataArray;
=======

>>>>>>> 6f60c5d6a780eed729db39d18f7847c3af93f697

@end
