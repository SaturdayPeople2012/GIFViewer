//
//  ListViewController.h
//  GIFViewer
//
//  Created by 양원석 on 12. 10. 22..
//  Copyright (c) 2012년 양원석. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListCell.h"
@interface ListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>{
    UIBarButtonItem *editButton;
    UIBarButtonItem *deleteButton;
    UIBarButtonItem *closeButton;
    
    UIBarButtonItem *loadButton;
    UIBarButtonItem *flexible;

}

@property (strong,nonatomic) NSArray *listData;


@end
