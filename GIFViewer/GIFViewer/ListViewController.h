//
//  ListViewController.h
//  GIFViewer
//
//  Created by 양원석 on 12. 10. 22..
//  Copyright (c) 2012년 양원석. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>{
    
    NSArray *items;
}
//@property (weak, nonatomic) IBOutlet UITableViewCell *tableView;

@end
