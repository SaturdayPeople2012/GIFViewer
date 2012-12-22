//
//  GridViewController.h
//  GIFViewer
//
//  Created by 양원석 on 12. 10. 22..
//  Copyright (c) 2012년 양원석. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCImagePickerDemoAppDelegate.h"
#import "ELCImagePickerDemoViewController.h"
#import "ELCImagePickerController.h"
#import "ELCAlbumPickerController.h"

@interface GridViewController : UIViewController <UICollectionViewDelegate,UICollectionViewDataSource,ELCImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *gridView;

@property (strong, nonatomic) NSMutableArray *gifDataArray;

@property (assign, nonatomic) BOOL editMode;

@property (strong, nonatomic) UIBarButtonItem *editBtn;

@end
