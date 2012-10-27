//
//  GridViewController.m
//  GIFViewer
//
//  Created by 양원석 on 12. 10. 22..
//  Copyright (c) 2012년 양원석. All rights reserved.
//

#import "GridViewController.h"
#import "GridCell.h"
#define kGridMode 0
#define kListMode 1
@interface GridViewController ()

@end

@implementation GridViewController
static NSString *CellIdentifier = @"Cell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.gridView registerClass:[GridCell class] forCellWithReuseIdentifier:CellIdentifier];
    
    UIBarButtonItem *editBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                            target:self action:@selector(goEdit:)];
    UIBarButtonItem *loadBtn = [[UIBarButtonItem alloc]initWithTitle:@"Load" style:UIBarButtonItemStyleBordered
                                                              target:self action:@selector(goLoad:)];
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                                 UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    self.navigationItem.rightBarButtonItem = editBtn;
    //////////////////////////////////////////////////////
    //TODO: 추후 AppDelegate로 뺄것!
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"Grid",@"List"]];
    segmentedControl.selectedSegmentIndex=0;
    segmentedControl.frame = CGRectMake(0, 0, 130, 30);
    [segmentedControl addTarget:self action:@selector(selectedMode:) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *segBtn = [[UIBarButtonItem alloc]initWithCustomView:segmentedControl];
    
    
    /////////////////////////////////////////////////////
    self.toolbarItems = [NSArray arrayWithObjects:flexible, segBtn,flexible, loadBtn, nil];
    // Do any additional setup after loading the view from its nib.
}

- (void) selectedMode:(id)sender{
    UISegmentedControl *control = sender;
    //TODO: 추후 AppDelegate로 뺄것!
    switch (control.selectedSegmentIndex) {
        case kGridMode:
            
            break;
        case kListMode:
            break;
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UIBarButton 관련 매서드
- (void)goEdit:(id)sender{
    
}

//기명이형 클래스와 연결
- (void)goLoad:(id)sender{
    
}


#pragma mark - UICollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.label.text = [NSString stringWithFormat:@"%d번째",indexPath.row];
    return cell;
}


@end
